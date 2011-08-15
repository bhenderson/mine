declare -a ARGV
for arg; do
  case "$arg" in
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

if [[ "$opt_remote" ]]; then
  list_remote_rubies "$1"
  exit
fi

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

# for listing remote versions:

# TODO how to get a 'cache' of all versions >= 1.8?
# curl -sS 'ftp://ftp.ruby-lang.org/pub/ruby/1.{8,9}/' | grep -o 'ruby.*tar.gz' > .ruby_cache
