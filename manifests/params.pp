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

  case $::architecture {
    'x86_64', 'amd64': { $plugindir = '/usr/lib64/nagios/plugins' }
    default:  { $plugindir = '/usr/lib/nagios/plugins' }
  }

  case $::operatingsystem {
    'gentoo', 'sabayon': {
      $confd            = '/etc/nagios/nrpe.d'
      $nrpe_name        = 'nrpe'
      $nrpe_service     = 'nrpe'
      $sysconf          = '/etc/conf.d/nrpe'
      $sysconf_template = 'nrpe/nrpe-sysconfig.erb'
      $use_sysconf      = true
      $pluginspackage   = 'nagios-plugins'
      $pid_file         = '/run/nrpe.pid'
      $nrpe_user        = 'nagios'
      $nrpe_group       = 'nagios'
    }
    'centos', 'redhat', 'fedora', 'scientific', 'oel': {
      $confd            = '/etc/nrpe.d'
      $nrpe_name        = 'nrpe'
      $nrpe_service     = 'nrpe'
      $sysconf          = '/etc/sysconfig/nrpe'
      $sysconf_template = 'nrpe/nrpe-sysconfig.erb'
      $use_sysconf      = true
      $pluginspackage   = 'nagios-plugins-all'
      $pid_file         = '/var/run/nrpe/nrpe.pid'
      $nrpe_user        = 'nrpe'
      $nrpe_group       = 'nrpe'
    }
    default: {
      fail("The ${module_name} module is not support on ${::operatingsystem}")
    }
  }
}
