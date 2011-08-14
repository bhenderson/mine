opt="$1"

source 'use.sh' "$opt"

warn "removing '$mine_ruby'"
(
  cd "$rubies_path"
  rm -f "$mine_ruby"
)

export mine_ruby="$orig_ruby"
