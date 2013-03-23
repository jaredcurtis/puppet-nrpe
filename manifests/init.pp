# Class: nrpe
#
#   This module manages the nrpe service.
#
#   Jared Curtis <jcurtis@ncircle.com>
#   2012-01-13
#
#   Garrett Honeycutt <code@garretthoneycutt.com>
#   2012-01-18
#
#   Tested platforms:
#    - CentOS 5.6
#    - CentOS 6.3
#
# Parameters:
#
# Actions:
#
#  Installs, configures, and manages the nrpe service.
#
# Requires:
#
#  You'll probably need EPEL installed
#
# Sample Usage:
#
#   class { "nrpe":
#     version => 'installed',
#     ssl     => true,
#   }
#
#   nrpe::command {
#        'check_command':  value => 'check_command';
#        'check_command2': value => 'check_command2';
#   }
#
#   nrpe::config {
#        debug => 0,
#        command_prefix => '/usr/bin/sudo'
#   }
#
#   Override Example:
#   Nrpe::Command[['check_users']] {
#       cmd => "check_users -w 50 -c 10",
#   }
#
#   Nrpe::Config[['nrpe.cfg']] {
#       allowed_hosts +> '1.1.1.1,',
#   }
#
class nrpe (
  $service_ensure=running,
  $service_enable=true,
  $version='UNSET',
  $ssl=false
) {

  include nrpe::params

  if $version == 'UNSET' {
    $version_real = 'installed'
  } else {
    $version_real = $version
  }

  if $ssl == true {
    $ssl_real = '-n'
  } else { $ssl_real = '' }

  if ! defined(Package[$nrpe::params::pluginspackage]) {
    package { $nrpe::params::pluginspackage : ensure => present }
  }

  package { 'nrpe':
    ensure => $version_real,
    name   => $nrpe::params::nrpe_name,
  }

  service { 'nrpe':
    ensure     => $service_ensure,
    name       => $nrpe::params::nrpe_service,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => Package['nrpe'],
  }

  if $nrpe::params::use_sysconf == true {
    file { $nrpe::params::sysconf:
      path    => $nrpe::params::sysconf,
      content => template($nrpe::params::sysconf_template),
      owner   => $nrpe::params::user,
      group   => $nrpe::params::group,
      mode    => '0644',
      notify  => Service['nrpe'],
    }
  }

  file { $nrpe::params::confd:
    ensure  => directory,
    path    => $nrpe::params::confd,
    owner   => $nrpe::params::user,
    group   => $nrpe::params::group,
    mode    => '0755',
    notify  => Service['nrpe'];
  }
}
