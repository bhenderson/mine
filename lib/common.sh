export rubies_path=$mine_path/rubies

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

list_rubies() {
  opt="${1-.}"

  pat() {
    echo "$opt" | sed 's/./&*/g'
  }

  # list all directories
  (
    cd $rubies_path
    find * -prune -name `pat`
  )
}

