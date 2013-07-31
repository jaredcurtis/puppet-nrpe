define nrpe::config(
  $log_facility='daemon',
  $pid_file='UNSET',
  $server_port='5666',
  $server_address='UNSET',
  $nrpe_user='UNSET',
  $nrpe_group='UNSET',
  $allowed_hosts='127.0.0.1,',
  $dont_blame_nrpe='0',
  $command_prefix='UNSET',
  $nrpedebug='0',
  $command_timeout='60',
  $connection_timeout='300',
  $allow_weak_random_seed='UNSET',
  $includecfg='UNSET',
  $include_dir='UNSET'
) {
  include nrpe::params

  $pid_file_real = $pid_file ? {
    'UNSET' => $nrpe::params::pid_file,
    default => $pid_file,
  }

  $nrpe_user_real = $nrpe_user ? {
    'UNSET' => $nrpe::params::nrpe_user,
    default => $nrpe_user,
  }

  $nrpe_group_real = $nrpe_group ? {
    'UNSET' => $nrpe::params::nrpe_group,
    default => $nrpe_group,
  }

  $include_dir_real = $include_dir ? {
    'UNSET' => $nrpe::params::confd,
    default => $include_dir,
  }

  file { $nrpe::params::conf:
    content => template('nrpe/nrpe.cfg.erb'),
    owner   => $nrpe::params::user,
    group   => $nrpe::params::group,
    mode    => '0644',
    notify  => Service['nrpe'];
  }
}
