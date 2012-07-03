# == Class: etckeeper
#
# Configure and install etckeeper. Works for debian-like and
# redhat-like systems.
#
# === Variables
#
# [*etckeeper_high_pkg_mgr*]
#   OS dependent config setting, HIGHLEVEL_PACKAGE_MANAGER.
#
# [*etckeeper_low_pkg_mgr*]
#   OS dependent config setting, LOWLEVEL_PACKAGE_MANAGER.
#
# === Examples
#
#   include etckeeper
#
# === Authors
#
# Thomas Van Doren
#
# === Copyright
#
# Copyright 2012, Thomas Van Doren, unless otherwise noted
#
class etckeeper {
  # HIGHLEVEL_PACKAGE_MANAGER config setting.
  $etckeeper_high_pkg_mgr = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => 'apt',
    /(?i-mx:centos|fedora|redhat)/ => 'yum',
  }

  # LOWLEVEL_PACKAGE_MANAGER config setting.
  $etckeeper_low_pkg_mgr = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => 'dpkg',
    /(?i-mx:centos|fedora|redhat)/ => 'rpm',
  }

  Package {
    ensure => present,
  }
  package { 'git': }
  package { 'etckeeper':
    require => [ Package['git'],
                 File['etckeeper.conf'],
                 ],
  }
  file { '/etc/etckeeper':
    ensure => directory,
  }
  file { 'etckeeper.conf':
    ensure  => present,
    path    => '/etc/etckeeper/etckeeper.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('etckeeper/etckeeper.conf.erb'),
  }
  exec { 'etckeeper-init':
    command => '/usr/bin/etckeeper init',
    cwd     => '/etc',
    creates => '/etc/.git',
    require => [ Package['git'], Package['etckeeper'], ],
  }
}
