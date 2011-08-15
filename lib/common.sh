# bash 3?

set -o pipefail

export mine_bin=$mine_path/bin
export rubies_path=$mine_path/rubies

mkdir -p "$rubies_path" &>/dev/null || abort 'unable to create rubies dir.'

warn() {
  printf "%s\n" "$@" >&2
}

abort() {
  warn "$@"
  exit 1
}

list_rubies() {
  arg="$1"

  pat() {
    echo "$arg" | sed 's/./&.*/g'
  }

  # list all directories
  (
    cd "$rubies_path"
    ls | grep "`pat`"
  )
}

# TODO dry up
list_remote_rubies() {
  arg="$1"

  pat() {
    echo "$arg" | sed 's/./&.*/g'
  }

  (
    cd "$mine_path"
    grep "`pat`"
  )
}

reset_ruby() {
  [[ "$orig_ruby" ]] && export mine_ruby="$orig_ruby"
}

rubies_bin_path() {
  echo "$rubies_path/$mine_ruby/bin"
}

set_path() {
  PATH=$(printf ':%s' $(echo -e ${PATH//:/\\n} | grep -v "$mine_path"))
  PATH="`rubies_bin_path`:$mine_bin$PATH"
  export PATH
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

set_system() {
  # command doesn't always work :(
  #system_ruby="`command -vp ruby`" || return
  system_ruby="`which -a ruby | grep -v "$mine_path" | head -n1`" || return

  (
    cd "$rubies_path"
    ln -s "`dirname $system_ruby`" system
  )
}

set_original_ruby() {
  export orig_ruby="$mine_ruby"
}

update_ruby() {
  #[[ "$orig_ruby" == "$mine_ruby" ]] && return
  set_path
  reset_ruby

cat >&3 <<-EOS
  export mine_ruby="$mine_ruby"
  export PATH="$PATH"
  ls "`rubies_bin_path`" | xargs hash -d
EOS
}

# make sure system is setup
[[ -d "$rubies_path/system" ]] || set_system
