option="$1"
mine_ruby="$option"

# exact match?
[ -d "$rubies_path/$mine_ruby" ] && return

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
