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
  cd "$rubies_path"
  for ruby in *; do
    (
      [[ -h $ruby ]] && continue

      cd $ruby/bin
      # not symbolic link?
      if [[ ! -h ruby ]]; then
        pwd
        mv -f ruby .ruby
        ln -fs "$mine_bin/.shim" ruby
      fi
    )
  done
)
