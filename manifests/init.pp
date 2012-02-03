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
#
# Parameters:
#
# Actions:
#
#  Installs, configures, and manages the nrpe service.
#
# Requires:
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
  $version= $nrpe::params::version,
  $ssl    = $nrpe::params::ssl,
  $ensure = $nrpe::params::ensure,
  $enable = $nrpe::params::enable,
  $hasstatus = $nrpe::params::hasstatus,
  $hasrestart= $nrpe::params::hasrestart
) {
  include nrpe::params

  if $ssl == true {
    $ssl_real = '-n'
  } else { $ssl_real = '' }

  case $ssl {
    'true':  { $ssl_real = '-n' }
    default: { $ssl_real = '' }
  }

  if ! ($ensure in ['running','true','stopped','false']) {
    fail("Invalid ensure value, $ensure, passed to nrpe")
  }

  package { 'nrpe':
    ensure => $version,
    name   => $nrpe::params::nrpe_name,
  }

  service { 'nrpe':
    ensure     => $ensure,
    name       => $nrpe::params::nrpe_service,
    enable     => $enable,
    hasstatus  => $hasstatus,
    hasrestart => $hasrestart,
    subscribe  => Package['nrpe'],
  }

  if $nrpe::params::use_sysconf == true {
    file { '/etc/sysconf/nrpe':
      path    => $nrpe::params::sysconf,
      content => template($nrpe::params::sysconf_template),
      owner   => $nrpe::params::user,
      group   => $nrpe::params::group,
      mode    => '0644',
      notify  => Service['nrpe'],
    }
  }

  file { '/etc/nrpe.d':
    ensure  => directory,
    path    => $nrpe::params::confd,
    owner   => $nrpe::params::user,
    group   => $nrpe::params::group,
    mode    => '0755',
    notify  => Service['nrpe'];
  }
}
