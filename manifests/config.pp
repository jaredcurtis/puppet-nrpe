define nrpe::config(
  $log_facility='daemon',
  $pid_file='/var/run/nrpe/nrpe.pid',
  $server_port='5666',
  $server_address='UNSET',
  $nrpe_user='nrpe',
  $nrpe_group='nrpe',
  $allowed_hosts='127.0.0.1,',
  $dont_blame_nrpe='0',
  $command_prefix='UNSET',
  $nrpedebug='0',
  $command_timeout='60',
  $connection_timeout='300',
  $allow_weak_random_seed='UNSET',
  $includecfg='UNSET',
  $include_dir='/etc/nrpe.d/'
) {
  include nrpe::params

  file { $nrpe::params::conf:
    content => template('nrpe/nrpe.cfg.erb'),
    owner   => $nrpe::params::user,
    group   => $nrpe::params::group,
    mode    => '0644',
    notify  => Service['nrpe'];
  }
}
