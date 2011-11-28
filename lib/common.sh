# bash 3?

set -o pipefail

# is there a better way to test FD 3?
[[ -a "/dev/fd/3" ]] || exec 3>&1

export mine_bin=$mine_path/bin
export rubies_path=$mine_path/rubies
mine_cache="$mine_path/.ruby_cache"

# colorize
[[ "$GREP_OPTIONS" =~ "--color" ]] ||
  export GREP_OPTIONS="$GREP_OPTIONS --color"

abort() {
  warn "$@"
  exit 1
}

warn() {
  [[ -z "$opt_quiet" ]] && printf "%s\n" "$@"
}

mkdir -p "$rubies_path" &>/dev/null || abort 'unable to create rubies dir.'

disambiguate() {
  local remote="$1"
  local orig="$mine_ruby"
  test "$remote" == 'remote' &&
    mine_ruby=( $(list_remote_rubies $mine_ruby) ) ||
    mine_ruby=( $(list_rubies $mine_ruby) )

  case "${#mine_ruby[@]}" in
    0)
      abort "unable to find '$orig'"
    ;;
    1)
      : # found!
    ;;
    *)
      abort "which?" "${mine_ruby[@]}"
    ;;
  esac
}

# for listing remote versions:
get_ruby_cache() {
  test -n "$opt_recache" -o ! -s "$mine_cache" || return
  echo 'getting cache'
  curl -sS 'ftp://ftp.ruby-lang.org/pub/ruby/1.{8,9}/' |
    grep -o 'ruby.*tar.gz' |
    progress "$mine_cache"
}

list_rubies() {
  # list all directories
  (
    cd "$rubies_path"
    ls | string_search "$@"
  )
}

# TODO dry up
list_remote_rubies() {
  (
    cd "$mine_path"
    get_ruby_cache
    cat "$mine_cache" | string_search "$@"
  )
}

# TODO `use' should be default. ie. mine 192
parse_opts() {
  case "$1" in
    help)
      [[ "$2" ]] && parse_opts "$2" "--help"
      usage
    ;;
    alias|copy|install|list|remove|setup|update|use)
      cmd=$1; shift
      source "$cmd.sh" "$@"
    ;;
    # shortcuts
    ls)
      shift
      source "list.sh" "$@"
    ;;
    --reset-system)
      reset_system
      shift
    ;;
    *)
      usage "unknown option '$1'"
    ;;
  esac
}

progress() {
  n=0

  clear() {
    printf '%80s\r' '' # clear
  }

  tee "$@" | while read; do
    clear
    printf '%3d% *s\r' $(( n / 77 )) $(( ++n % 77 )) '>'
  done

  clear
  echo "done."
}

reset_ruby() {
  [[ "$orig_ruby" ]] && export mine_ruby="$orig_ruby"
}

reset_system() {
  (
    cd "$rubies_path"
    rm -f system
  )
  set_system
}

rubies_bin_path() {
  echo "$rubies_path/$mine_ruby/bin"
}

string_search() {
  local pat="`echo "$1" | sed 's/./.*&/g'`"
  grep "${pat:2}"
}

set_default() {
  echo 'setting default ruby.'
  (
    cd "$rubies_path"
    rm -f default &>/dev/null
    ln -s "$mine_ruby" default
  )
  export mine_ruby=default
}

set_path() {
  PATH=$(printf ':%s' $(echo -e ${PATH//:/\\n} | grep -v "$mine_path"))
  PATH="`rubies_bin_path`:$mine_bin$PATH"
  export PATH
}

# TODO this actually needs to be such that system/bin/ruby exists
set_system() {
  # command doesn't always work :(
  #system_ruby="`command -vp ruby`" || return
  system_ruby="`which -a ruby | grep -v "$mine_path" -m1`" || return

  (
    cd "$rubies_path"
    ln -s "`dirname $system_ruby`" system
  )
}

set_original_ruby() {
  export orig_ruby="$mine_ruby"
}

set_fall_back_ruby() {
  (
    cd "$rubies_path"
    [[ -d "default" ]] && mine_path=default ||
    [[ -d "system" ]] && mine_path=default ||
    warn 'no default ruby to fall back on. set with mine use <ruby> --default'
  )
}

update_ruby() {
  # is ruby empty?
  [ -z "$mine_ruby" ] &&
    # did we change ruby? then don't bother
    [[ "$orig_ruby" == "$mine_ruby" ]] &&
    return

  set_path
  reset_ruby

  cat >&3 <<-EOS
export mine_ruby="$mine_ruby"
export PATH="$PATH"
[[ -d "$(rubies_bin_path)" ]] && hash -d \$(ls $(rubies_bin_path)) &>/dev/null
EOS
}

export command_name=mine
usage() {
  [[ "$1" ]] && printf "%s\n" "$@"

  cat <<-EOS
Usage: $command_name [command] [options]

  Commands:
    alias
    copy
    help
    install
    list
    remove
    setup
    update
    use

EOS
  exit 1
}

# make sure system is setup
[[ -d "$rubies_path/system" ]] || set_system
