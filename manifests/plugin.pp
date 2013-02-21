define nrpe::plugin(
  $plugin=$name,
  $plugindir=$nrpe::plugindir,
) {
  file { "${plugindir}/${plugin}":
    ensure  => file,
    source  => "puppet:///modules/${module_name}/${plugin}",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Service[$nrpe::nrpe_service],
    require => Package[$nrpe::plugins_package],
  }
}
