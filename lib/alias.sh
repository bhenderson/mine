ruby="$1"
alias="$2"

source 'use.sh' "$ruby"
(
  cd "$rubies_path"
  [[ -a "$alias" ]] && abort "alias '$alias' already exists."

  ln -s "$mine_ruby" "$alias"
)

export mine_ruby="$orig_ruby"
