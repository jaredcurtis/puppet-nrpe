define nrpe::command(
  $cmd,
  $cmdname=$name,
  $ensure='present'
) {
  case $ensure {
    absent,present: {}
    default: {
      fail("Invalid ensure value passed to Nrpe::Command[$name]")
    }
  }

  file { "${nrpe::params::confd}/${cmdname}.cfg":
    ensure  => $ensure,
    content => template('nrpe/nrpe-command.cfg.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['nrpe'],
    notify  => Service['nrpe'],
  }
}
