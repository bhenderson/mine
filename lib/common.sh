export rubies_path=$mine_path/rubies
export orig_ruby="$mine_ruby"

warn() {
  printf "%s\n" "$@" >&2
}

abort() {
  warn "$@"
  exit 1
}

list_rubies() {
  opt="$1"

  pat() {
    echo "$opt" | sed 's/./&.*/g'
  }

  # list all directories
  (
    cd "$rubies_path"
    ls | grep "`pat`"
  )
}

update_ruby() {
  [[ "$orig_ruby" == "$mine_ruby" ]] && return

cat >&3 <<-EOS
  export mine_ruby="$mine_ruby"
  export GEM_HOME="$mine_path/rubies/$mine_ruby/gems"
  export GEM_PATH="$mine_path/rubies/$mine_ruby/gems"
EOS
}
