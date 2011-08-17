ruby="$1"
alias="$2"

set_original_ruby

source 'use.sh' "$ruby"
(
  cd "$rubies_path"
  [[ -a "$alias" ]] && abort "alias '$alias' already exists."

  ln -s "$mine_ruby" "$alias"
)
