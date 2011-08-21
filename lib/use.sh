option="$1"; shift

usage() {
  cat <<-EOU
Usage: $command_name use rubish

  Sets and new ruby to rubish.
  "rubyish" is searched for using shortest match. Matching characters do not
  have to be sequencial.

EOU
  exit 1
}

case "$option" in
  -h|--help)
    usage
  ;;
esac
mine_ruby="$option"

disambiguate() {
  pat() {
    echo $mine_ruby | sed 's/./&.*/g'
  }

  mine_ruby=( $(list_rubies $mine_ruby) )

  case "${#mine_ruby[@]}" in
    0)
      abort "unable to find '$option'"
    ;;
    1)
      : # found!
    ;;
    *)
      abort "which?" "${mine_ruby[@]}"
    ;;
  esac
}

# exact match?
[ -d "$rubies_path/$mine_ruby" ] || disambiguate

# parse extra opts
case "$1" in
  --default)
    set_default
  ;;
esac
