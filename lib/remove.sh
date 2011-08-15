opt="$1"

trap_reset_original_ruby

source 'use.sh' "$opt"

warn "removing '$mine_ruby'"
(
  cd "$rubies_path"
  rm -rf "$mine_ruby"
)

