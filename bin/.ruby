#!/bin/bash

# use a shim because rubygems installs executables with an absolute path to the
# current ruby. Usecase is: install ruby 1.9.2, and 1.9.3. Under 1.9.2, bundle
# install rack. 'rackup' points to ruby 1.9.2. Switch to 1.9.3, bundle install
# will keep same rack gem (vender/bundle/1.9.1). When the user runs rackup, it
# will call the 1.9.2 ruby instead of whatever is set by the env.

# if you want to explicitely run a specific version of ruby, you could run
# $rubies_path/$version/bin/.ruby

# this will pickup the first .ruby available in your PATH (set by mine)
exec -a "$(which ruby)" .ruby "$@"
