# my guess is that this site has "head"
#http://ftp.ruby-lang.org/pub/ruby/
# all known:
#http://ftp.ruby-lang.org/pub/ruby/1.8/

trap_reset_original_ruby

export mine_ruby="$1"

fetch_tgz() {
  remote="$1"
  file=`basename $remote`
  if [[ -z "$skip_cache" && -s "$file" ]]; then
    echo "using cached copy"
  else
    echo "downloading $mine_ruby"
    curl -f -# "$remote" --remote-name || abort "failed to download $remote"
  fi
}

install_ruby() {
  [[ "$mine_ruby" ]] || abort 'ruby version string required.'

  local src="$mine_path/src"
  local prefix="$mine_path/rubies/$mine_ruby"
  local log="$src/install.log"

  set -e
  trap 'echo "interrupted. quiting."; rm -rf "$prefix"' INT
  trap 'echo "there was a problem. check "$log" for details."; rm -rf "$prefix"' ERR

  mkdir -p $src >/dev/null

  (
    cd $src
    # TODO 1.8.x
    fetch_tgz "http://ftp.ruby-lang.org/pub/ruby/`strip_version`/$mine_ruby.tar.gz"
    echo extracting.
    tar xzvf $mine_ruby.tar.gz | progress "/dev/null"

    (
      cd $mine_ruby
      echo configuring.
      : > $log
      # TODO flag to override this? is this only helpful in debugging?
      if [[ -s "Makefile" ]]; then
        echo 'Makefile present. skipping.'
      else
        ./configure --prefix="$prefix" 2>&1 | progress -a "$log"
      fi

      # TODO error checking
      echo compiling.
      make 2>&1 | progress -a "$log"
      echo installing.
      make install 2>&1 | progress -a "$log"
    )

    [[ -d "$rubies_path/default" ]] || set_default

    #TODO how should we pick this version? it's also a little weird that we
    # don't set this var inside the function.

    # already installed?
    if [[ ! -a "`rubies_bin_path`/gem" ]]; then
      rubygems=rubygems-1.3.7
      echo Installing $rubygems
      install_rubygems 2>&1 | progress -a "$log"
    fi
  )
}

# TODO how to get current rubygems rather than hardcode 1.3.7
install_rubygems() {
  fetch_tgz "http://production.cf.rubygems.org/rubygems/$rubygems.tgz"
  tar xzf $rubygems.tgz
  (
    cd $rubygems
    ruby setup.rb
  )
}

progress() {
  n=0

  clear() {
    printf '%80s\r' '' # clear
  }

  tee "$@" | while read; do
    clear
    printf '%3d% *s\r' $(( n / 77 )) $(( ++n % 77 )) '>'
  done

  clear
  echo "done."
}

set_system() {
  # command doesn't always work :(
  #system_ruby="`command -vp ruby`" || return
  system_ruby="`which -a ruby | grep -v "$mine_path" | head -n1`" || return

  (
    cd "$rubies_path"
    ln -s "`dirname $system_ruby`" system
  )
}

strip_version() {
  echo "$mine_ruby" | grep -o '[0-9]\+\.[0-9]\+'
}

[[ -d "$rubies_path/system" ]] || set_system
install_ruby
