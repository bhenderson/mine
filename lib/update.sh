###
# mine update
#
# run this in order to upgrade mine.
# Originally, I wanted to just run git pull, but I needed a way to run an
# update script per version


(
  # update the code
  cd "$mine_path"
  git pull

  # update everything else
  source "_latest_update.sh" "$@"
)
