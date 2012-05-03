puppet-perl
===========

Simple puppet class to manage packaged Perl CPAN modules.

Usage instructions are provided in the init.pp file with examples.

This class requires the latest version (YAML enabled) version of the extlookup puppet
plugin. The init.pp has instructions on how to comment out the functionality that requires
extlookup. If you want to use it but don't have it installed, please check:

https://github.com/ripienaar/puppet-extlookup
