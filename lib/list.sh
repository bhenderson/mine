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
  } | cut -d/ -f2- | grep --color -e "$mine_ruby" -e ''
)
