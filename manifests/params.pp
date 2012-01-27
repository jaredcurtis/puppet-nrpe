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

  case $::architecture {
    'x86_64': { $plugindir = '/usr/lib64/nagios/plugins' }
    default:  { $plugindir = '/usr/lib64/nagios/plugins' }
  }

  case $::operatingsystem {
    'centos', 'redhat', 'fedora', 'scientific': {
      $nrpe_name    = 'nrpe'
      $nrpe_service = 'nrpe'
      $sysconf      = '/etc/sysconfig/nrpe'
      $sysconf_template = 'nrpe/nrpe-sysconfig.erb'
      $use_sysconf  = true
    }
    default: {
      fail("The ${module_name} module is not support on ${::operatingsystem}")
    }
  }
}
