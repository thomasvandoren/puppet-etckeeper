require 'spec_helper'

describe 'etckeeper', :type => 'class' do
  context "On a Debian OS" do
    let :facts do
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu'
      }
    end # let

    it do
      should contain_package('git-core').with_ensure('present')
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

      should contain_exec('etckeeper-init').with(:command => '/usr/sbin/etckeeper init',
                                                 :cwd     => '/etc',
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
      should contain_package('git').with_ensure('present')
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

      should contain_exec('etckeeper-init').with(:command => '/usr/bin/etckeeper init',
                                                 :cwd     => '/etc',
                                                 :creates => '/etc/.git')
    end # it
  end # context
end # describe
