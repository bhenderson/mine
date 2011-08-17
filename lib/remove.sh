opt="$1"

set_original_ruby

source 'use.sh' "$opt"

warn "removing '$mine_ruby'"
(
  cd "$rubies_path"
  rm -rf "$mine_ruby"

  # remove symlinks that don't point anywhere
  for link in *; do
    [[ -h "$link" -a ! -d "$link" ]] && rm -f "$link"
  done
)

set_fall_back_ruby
