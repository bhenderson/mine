option="$1"; shift
mine_ruby="$option"

disambiguate() {
  pat() {
    echo $mine_ruby | sed 's/./&.*/g'
  }

  mine_ruby=( $(list_rubies | grep "$(pat)") )

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
