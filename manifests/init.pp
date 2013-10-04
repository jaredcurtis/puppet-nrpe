# == Class: nrpe
#
# This module manages nrpe configuration and nagios-plugins
#
# === Parameters:
# [*allowed_hosts*]
#   string, containing IPs of hosts, which can connect to the NRPE service
#
# === Examples
# Example:
# class { 'nrpe':
#   allowed_hosts => [ '127.0.0.1', '12.34.56.78' ],
# }
#
# nrpe::command {
#   'check_users': cmd => 'check_users -w 5 -c 10';
#   'check_load':  cmd => 'check_load -w 15,10,5 -c 30,25,20';
#   'check_disks': cmd => 'check_disk -w 20% -c 10%';
#   'check_zombie_procs': cmd => 'check_procs -w 5 -c 10 -s Z';
#   'check_total_procs':  cmd => 'check_procs -w 150 -c 250';
# }
#
# nrpe::plugin {'check_cpu.sh':}
# nrpe::plugin {'check_cron':}
# nrpe::plugin {'check_backup':}
#
# === Authors
# Jared Curtis <jcurtis@ncircle.com>
# Garrett Honeycutt <code@garretthoneycutt.com>
# Michael Moll <mmoll@mmoll.at>
#
# === Copyright
#
# Copyright 2012 by Jared Curtis
# Copyright 2012 by Garrett Honeycutt
# Copyright 2013 by Michael Moll
#
class nrpe ($allowed_hosts=['127.0.0.1']) {

validate_array($allowed_hosts)
$ahosts = join( $allowed_hosts, ',' )

  $log_facility='daemon'
  $server_port='5666'
  $server_address='UNSET'
  $dont_blame_nrpe='0'
  $command_prefix='UNSET'
  $nrpedebug='0'
  $command_timeout='60'
  $connection_timeout='300'
  $allow_weak_random_seed='UNSET'
  $includecfg='UNSET'

  case $::osfamily {
    'redhat': {
      $nrpe_cfg        = '/etc/nagios/nrpe.cfg'
      $pid_file        = '/var/run/nrpe.pid'
      $nrpe_user       = 'nagios'
      $nrpe_group      = 'nagios'
      $include_dir     = '/etc/nagios/nrpe.d/'
      $nrpe_package    = 'nagios-nrpe'
      $nrpe_service    = 'nrpe'
      $plugins_package = 'nagios-plugins'
      case $::architecture {
        'x86_64': { $plugindir = '/usr/lib64/nagios/plugins' }
        default:  { $plugindir = '/usr/lib/nagios/plugins' }
      }
    }
    'suse': {
      $nrpe_cfg        = '/etc/nagios/nrpe.cfg'
      $pid_file        = '/var/run/nrpe/nrpe.pid'
      $nrpe_user       = 'nagios'
      $nrpe_group      = 'nagios'
      $include_dir     = '/etc/nagios/nrpe.d/'
      $nrpe_package    = 'nagios-nrpe'
      $nrpe_service    = 'nrpe'
      $plugins_package = 'nagios-plugins'
      $plugindir       = '/usr/lib/nagios/plugins'
    }
    'debian': {
      $nrpe_cfg        = '/etc/nagios/nrpe.cfg'
      $pid_file        = '/var/run/nagios/nrpe.pid'
      $nrpe_user       = 'nagios'
      $nrpe_group      = 'nagios'
      $include_dir     = '/etc/nagios/nrpe.d/'
      $nrpe_package    = 'nagios-nrpe-server'
      $nrpe_service    = 'nagios-nrpe-server'
      $plugins_package = 'nagios-plugins'
      $plugindir       = '/usr/lib/nagios/plugins'
    }
    default: {
      fail("The ${module_name} module is not support on ${::operatingsystem}")
    }
  }


  package { $plugins_package:
    ensure => installed,
  }

  package { $nrpe_package:
    ensure => installed,
  }

  $nrpehasstatus = $::lsbdistcodename ? {
    squeeze => false,
    default => true,
  }

  service { 'nrpe_service':
    ensure    => running,
    name      => $nrpe_service,
    enable    => true,
    require   => Package[$nrpe_package],
    hasstatus => $nrpehasstatus,
    pattern   => 'nrpe',
  }


  file { $include_dir:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    notify  => Service[$nrpe_service],
    require => Package[$nrpe_package],
  }

  file { $nrpe_cfg:
    content => template('nrpe/nrpe.cfg.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service[$nrpe_service],
    require => Package[$nrpe_package],
  }

}
