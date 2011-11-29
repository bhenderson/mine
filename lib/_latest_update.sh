###
# Place holder for any post update cleanup.

for r in "$rubies_path/*/bin"; do
  (
    cd $r
    rm -f ruby
    ln -s "$mine_bin/.ruby" ruby
  )
done
