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
    --remote)
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

[[ "$opt_remote" ]] && { list_remote_rubies "$1"; exit; }

rubies=(`list_rubies "$1"`)
(
  [[ "$rubies" ]] || abort 'none installed.'
  cd "$rubies_path"
  file_list="`printf "./%s " ${rubies[@]}`"

  {
    # list aliases
    find $file_list -prune -type l -ls
    # list rubies
    find $file_list -prune -type d -ls
  } | cut -d/ -f2- | grep  -e "$mine_ruby" -e ''
)
