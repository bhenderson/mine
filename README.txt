=== Description

A (simple) ruby manager.
Very alpha. no tests :(
but "works"

=== Install

  $ git clone git@github.com:bhenderson/mine.git ~/.mine
  $ source ~/.mine/bin/mine setup

=== Usage

ruby strings are expanded

  $ mine use 192p18
same as
  $ mine use ruby-1.9.2-p180

For other options:
  $ mine help

=== Gems

rubygems 1.3.7 (it's what came with 1.9.2 so I went with it) is the hardcoded
version that gets installed. The thought being that rubygems is now realy easy
for users to manage themselves. If you want a different version:

  $ gem update --system # latest

Specific version?

  $ gem update --system <version> (requires >= 1.5.2)

see http://rubygems.rubyforge.org/rubygems-update/UPGRADING_rdoc.html

=== Considerations

I like rvm (thank you wayne!)

I wanted to see if I could simplify it a little.

I wanted 99.9% of the work to be done in a subshell/script. The problem with
this is that a subshell can't update it's parent's env. So mine has to be a
function. See head of main bin.

=== TODO

  * tests!!!
  * copy # doing a straight cp -a does not work because of shebangs
  * get "current" ruby from CWD (allowing for .minerc files)
  * string_search does not choose exact match if longer match also exists
    * ie. 'ruby19, ruby192'
  * I want to clean up option parsing
  * lots of other things I can't think of right now
