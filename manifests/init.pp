# Class: nrpe
#
#   This module manages the nrpe service.
#
#   Jared Curtis <jared@shift-e.info>
#   2012-01-13
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
#       cmd => "check_users -w 50 -c 10"
#   }
#
#   Nrpe::Config[['nrpe.cfg']] {
#       allowed_hosts +> '1.1.1.1,',
#   }
#
class nrpe (
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

    package { 'nrpe':
        ensure => $version_real,
        name   => $nrpe::params::nrpe_name,
    }

    service { 'nrpe':
        ensure     => running,
        name       => $nrpe::params::nrpe_service,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
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
