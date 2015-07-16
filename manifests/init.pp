# == Class: etckeeper
#
# Configure and install etckeeper. Works for debian-like and
# redhat-like systems.
#
# === Parameters
#
# [*etckeeper_author*]
#   Author name to use when committing (user.name).
#   Default: false (do not set)
#
# [*etckeeper_email*]
#   Email to use when committing (user.email).
#   Default: false (do not set)
#
# [*push_remote_name*]
#   Automatic push to a remote branch after commit.
#   Default: undef (do not push)
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
# To set the author and email for git commits:
#
#   class { 'etckeeper':
#     etckeeper_author => 'root',
#     etckeeper_email  => "root@${::fqdn}",
#   }
#
# === Authors
#
# Thomas Van Doren
#
# === Copyright
#
# Copyright 2012, Thomas Van Doren, unless otherwise noted
#
class etckeeper (
  $etckeeper_author = false,
  $etckeeper_email = false,
  $push_remote_name = false, 
  ) {
  # HIGHLEVEL_PACKAGE_MANAGER config setting.
  $etckeeper_high_pkg_mgr = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/                           => 'apt',
    /(?i-mx:centos|fedora|redhat|oraclelinux|amazon)/ => 'yum',
  }

  # LOWLEVEL_PACKAGE_MANAGER config setting.
  $etckeeper_low_pkg_mgr = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/                           => 'dpkg',
    /(?i-mx:centos|fedora|redhat|oraclelinux|amazon)/ => 'rpm',
  }

  $gitpackage = $::operatingsystem ? {
    /(?i-mx:ubuntu|debian)/                           => 'git-core',
    /(?i-mx:centos|fedora|redhat|oraclelinux|amazon)/ => 'git',
  }

  Package {
    ensure => present,
  }

  if !defined(Package[$gitpackage]) {
    package { $gitpackage: }
  }

  package { 'etckeeper':
    require => [ Package[$gitpackage], File['etckeeper.conf'], ],
  }

  file { '/etc/etckeeper':
    ensure => directory,
    mode   => '0755',
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
    command => 'etckeeper init',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    cwd     => '/etc',
    creates => '/etc/.git',
    require => [ Package[$gitpackage], Package['etckeeper'], ],
  }
}
