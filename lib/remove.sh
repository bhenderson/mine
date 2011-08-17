opt="$1"

set_original_ruby

source 'use.sh' "$opt"

warn "removing '$mine_ruby'"
(
  cd "$rubies_path"
  rm -rf "$mine_ruby"
)

# TODO what do we do if we remove the default ruby?
export $mine_ruby=default
