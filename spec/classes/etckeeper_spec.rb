require 'spec_helper'

describe 'etckeeper', :type => 'class' do
  context "On an Ubuntu OS" do
    let :facts do
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu'
      }
    end # let

    it do
      should contain_class('git')

      should contain_package('etckeeper').with_ensure('present')

      should contain_file('/etc/etckeeper').with(:ensure => 'directory',
                                                 :mode   => '0755')
      should contain_file('etckeeper.conf').with(:ensure => 'present',
                                                 :path   => '/etc/etckeeper/etckeeper.conf',
                                                 :owner  => 'root',
                                                 :group  => 'root',
                                                 :mode   => '0644')
      should contain_file('etckeeper.conf').with_content(/^VCS="git"$/)
      should contain_file('etckeeper.conf').with_content(/^HIGHLEVEL_PACKAGE_MANAGER=apt$/)
      should contain_file('etckeeper.conf').with_content(/^LOWLEVEL_PACKAGE_MANAGER=dpkg$/)
      should contain_file('etckeeper.conf').with_content(/^GIT_COMMIT_OPTIONS=""$/)

      should contain_exec('etckeeper-init').with(:command => 'etckeeper init',
                                                 :cwd     => '/etc',
                                                 :path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                                                 :creates => '/etc/.git')
    end # it
  end # context

  context "On a RedHat OS" do
    let :facts do
      {
        :osfamily        => 'RedHat',
        :operatingsystem => 'CentOS'
      }
    end # let

    it do
      should contain_class('git')

      should contain_package('etckeeper').with_ensure('present')

      should contain_file('/etc/etckeeper').with(:ensure => 'directory',
                                                 :mode   => '0755')
      should contain_file('etckeeper.conf').with(:ensure => 'present',
                                                 :path   => '/etc/etckeeper/etckeeper.conf',
                                                 :owner  => 'root',
                                                 :group  => 'root',
                                                 :mode   => '0644')
      should contain_file('etckeeper.conf').with_content(/^VCS="git"$/)
      should contain_file('etckeeper.conf').with_content(/^HIGHLEVEL_PACKAGE_MANAGER=yum$/)
      should contain_file('etckeeper.conf').with_content(/^LOWLEVEL_PACKAGE_MANAGER=rpm$/)

      should contain_exec('etckeeper-init').with(:command => 'etckeeper init',
                                                 :cwd     => '/etc',
                                                 :path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                                                 :creates => '/etc/.git')
    end # it
  end # context

  context "On a Debian OS" do
    let :facts do
      {
        :operatingsystem => 'Debian'
      }
    end # let

    it do
      should contain_class('git')
      should contain_file('etckeeper.conf').with_content(/^HIGHLEVEL_PACKAGE_MANAGER=apt$/)
      should contain_file('etckeeper.conf').with_content(/^LOWLEVEL_PACKAGE_MANAGER=dpkg$/)
    end # it
  end # context

  context "On an Oracle Server 6 OS" do
    let :facts do
      {
        :operatingsystem => 'oraclelinux'
      }
    end # let

    it do
      should contain_class('git')
      should contain_file('etckeeper.conf').with_content(/^HIGHLEVEL_PACKAGE_MANAGER=yum$/)
      should contain_file('etckeeper.conf').with_content(/^LOWLEVEL_PACKAGE_MANAGER=rpm$/)
    end # it
  end # context

  context "On Ubuntu with author and email params" do
    let :facts do
      {
        :operatingsystem => 'Ubuntu'
      }
    end # let
    let :params do
      {
        :etckeeper_author => 'Roger Rabbit',
        :etckeeper_email  => 'roger@marooncartoons.com'
      }
    end # let

    it do
      should contain_file('etckeeper.conf').with_content(/^GIT_COMMIT_OPTIONS="--author='Roger Rabbit <roger@marooncartoons.com>'"$/)
    end # it
  end # context
end # describe
