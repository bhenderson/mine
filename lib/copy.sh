# copy ruby instead of just alias so that we can install a different gem version

ruby="$1"
copy="$2"

set_original_ruby

source 'use.sh' "$ruby"
(
  cd "$rubies_path"
  [[ -a "$copy" ]] && abort "copy '$copy' already exists."

  # mac cp doesn't have -l option
  # not sure if it's even helpful. seems like it takes less space.
  {
    cp -avl "$mine_ruby" "$copy"
    (( "$?" == 64 )) &&
      cp -av "$mine_ruby" "$copy"
  } 2>&1 | progress
)
