define nrpe::command(
  $cmd,
  $cmdname=$name,
  $cwd=$nrpe::plugindir,
  $ensure='present'
) {
  case $ensure {
    absent,present: {}
    default: {
      fail("Invalid ensure value passed to Nrpe::Command[${name}]")
    }
  }

  file { "${nrpe::include_dir}/${cmdname}.cfg":
    ensure  => $ensure,
    content => template('nrpe/nrpe-command.cfg.erb'),
    owner   => root,
    group   => $nrpe::root_group,
    mode    => '0644',
    require => File[$nrpe::include_dir],
    notify  => Service[$nrpe::nrpe_service],
  }
}
