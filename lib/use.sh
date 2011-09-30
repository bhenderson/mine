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
    -q|--quiet)
      opt_quiet=true
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

# exact match?
[ -d "$rubies_path/$mine_ruby" ] || disambiguate
[ "$opt_default" ] && set_default
