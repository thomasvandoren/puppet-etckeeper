etckeeper puppet module
=======================

Install and configure etckeeper using git.

[![Build Status](https://secure.travis-ci.org/thomasvandoren/puppet-etckeeper.png)](http://travis-ci.org/thomasvandoren/puppet-etckeeper)

Usage
-----
Installs etckeeper with git configuration.

```puppet
include etckeeper
```

Note that this module assumes the etckeeper package is available in
one of the available package repos. You may need to add EPEL (or
similar) on some EL distros.

Authors
-------
Thomas Van Doren

License
-------
BSD
