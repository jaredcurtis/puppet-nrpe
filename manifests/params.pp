# Class: nrpe::params
#
# This class manages NRPE parameters
#
# Parameters:
# - The $user that owns NRPE files
# - The $group that owns NRPE files
# - The $nrpe_name is the name of the package on the relevant distribution
# - The $nrpe_service is the name of the service on the relevant distribution
# - The $sysconf is the name of the NRPE options file
# - The $sysconf_template is the name of the NRPE options file template
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nrpe::params {
  $user  = 'root'
  $group = 'root'
  $conf  = '/etc/nagios/nrpe.cfg'
  $confd = '/etc/nrpe.d'

  # init.pp
  $version    ='installed'
  $ssl        ='false'
  $ensure     ='running'
  $enable     ='true'
  $hasstatus  ='true'
  $hasrestart ='true'

  # command.pp
  $log_facility           = 'daemon'
  $pid_file               = '/var/run/nrpe/nrpe.pid'
  $server_port            = '5666'
  $server_address         = 'UNSET'
  $nrpe_user              = 'nrpe'
  $nrpe_group             = 'nrpe'
  $allowed_hosts          = '127.0.0.1,'
  $dont_blame_nrpe        = '0'
  $command_prefix         = 'UNSET'
  $nrpedebug              = '0'
  $command_timeout        = '60'
  $connection_timeout     = '300'
  $allow_weak_random_seed = 'UNSET'
  $includecfg             = 'UNSET'
  $include_dir            = '/etc/nrpe.d/'

  case $::architecture {
    'x86_64': { $plugindir = '/usr/lib64/nagios/plugins' }
    default:  { $plugindir = '/usr/lib/nagios/plugins' }
  }

  case $::operatingsystem {
    'centos', 'redhat', 'fedora', 'scientific', 'oel': {
      $nrpe_name        = 'nrpe'
      $nrpe_service     = 'nrpe'
      $sysconf          = '/etc/sysconfig/nrpe'
      $sysconf_template = 'nrpe/nrpe-sysconfig.erb'
      $use_sysconf      = true
    }
    default: {
      fail("The ${module_name} module is not support on ${::operatingsystem}")
    }
  }
}
