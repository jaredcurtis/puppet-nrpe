define nrpe::config(
  $log_facility           = $nrpe::params::log_facility,
  $pid_file               = $nrpe::params::pid_file,
  $server_port            = $nrpe::params::server_port,
  $server_address         = $nrpe::params::server_address,
  $nrpe_user              = $nrpe::params::nrpe_user,
  $nrpe_group             = $nrpe::params::nrpe_group,
  $allowed_hosts          = $nrpe::params::allowed_hosts,
  $dont_blame_nrpe        = $nrpe::params::dont_blame_nrpe,
  $command_prefix         = $nrpe::params::command_prefix,
  $nrpedebug              = $nrpe::params::nrpedebug,
  $command_timeout        = $nrpe::params::command_timeout,
  $connection_timeout     = $nrpe::params::connection_timeout,
  $allow_weak_random_seed = $nrpe::params::allow_weak_random_seed,
  $includecfg             = $nrpe::params::includecfg,
  $include_dir            = $nrpe::params::include_dir
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
