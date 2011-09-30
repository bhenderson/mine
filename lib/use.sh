usage() {
  cat <<-EOU
Usage: $command_name use rubish

  Sets ruby in current env.

EOU
  exit 1
}

# parse options
declare -a ARGV
for arg; do
  case "$arg" in
    -h|--help)
      usage
    ;;
    --default)
      opt_default=true
      shift
    ;;
    *)
      ARGV+=("$1")
      shift
    ;;
  esac
done
set -- "${ARGV[@]}"
unset ARGV

mine_ruby="$1"

disambiguate() {
  local orig="$mine_ruby"
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

# exact match?
[ -d "$rubies_path/$mine_ruby" ] || disambiguate
[ "$opt_default" ] && set_default
