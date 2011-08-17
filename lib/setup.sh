
# something like
grep -q "^source .*mine/bin/mine" ~/.bashrc || {
  echo 'setting up mine in ~/.bashrc'
  cat >> ~/.bashrc <<-EOS

# installed by mine
source "$mine_path/bin/mine"
EOS
}
