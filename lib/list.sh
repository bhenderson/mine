usage() {
  cat <<-EOU
Usage: $command_name list [rubish]

  --remote:   list known remote rubies
  --help:     show this message

EOU
  exit 1
}

# TODO make this reusable?
declare -a ARGV
for arg; do
  case "$arg" in
    -h|--help)
      usage
    ;;
    -r|--remote)
      opt_remote=true
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

[[ "$opt_remote" ]] && { list_remote_rubies "$1"; exit; }

(
  cd $rubies_path
  {
    ls -ld ./* 2>/dev/null || abort 'no rubies installed'
  } |
    # sort links first (mac ls does not have -X option)
    sort -k 1,1r -k 9 |
    # only actually show the file
    cut -d/ -f2- |
    # limit based on user input
    ruby_string_search "$@" |
    # color current one
    grep -e "$mine_ruby" -e ''
)
