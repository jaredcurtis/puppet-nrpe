define nrpe::plugin(
  $plugin=$name,
  $plugindir=$nrpe::params::plugindir,
  $source="puppet:///modules/${module_name}/plugins/${plugin}"
) {
  include nrpe::params

  file { "${plugindir}/${plugin}":
    source  => $source,
    owner   => $nrpe::params::user,
    group   => $nrpe::params::group,
    mode    => '0755',
    notify  => Service['nrpe'];
  }
}
