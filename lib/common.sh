# bash 3?

set -o pipefail

export mine_bin=$mine_path/bin
export orig_ruby="$mine_ruby"
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

update_ruby() {
  #[[ "$orig_ruby" == "$mine_ruby" ]] && return
  set_path

cat >&3 <<-EOS
  export mine_ruby="$mine_ruby"
  export PATH="$PATH"
  ls "`rubies_bin_path`" | xargs hash -d
EOS
}

trap_reset_original_ruby() {
  trap 'export mine_ruby="$orig_ruby"' EXIT
}
