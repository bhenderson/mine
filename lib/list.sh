option="$1"

rubies=("`list_rubies "$1"`")
(
  cd "$mine_path"
  for ruby in ${rubies[@]}; do
    ls -ld "rubies/$ruby" | cut -d/ -f2
  done
)
