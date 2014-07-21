etckeeper puppet module
=======================

[![Build Status](https://secure.travis-ci.org/thomasvandoren/puppet-etckeeper.png)](http://travis-ci.org/thomasvandoren/puppet-etckeeper)

Install and configure etckeeper using git.

Usage
-----
Installs etckeeper with git configuration.

```puppet
include etckeeper
```

Note that this module assumes the etckeeper package is available in
one of the available package repos. You may need to add EPEL (or
similar) on some EL distros.

Development
-----------

To run the linter and spec tests locally:

```bash
bundle install --gemfile .gemfile
rake lint
rake spec
```

Authors
-------
Thomas Van Doren

License
-------
BSD
