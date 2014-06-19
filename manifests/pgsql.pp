# == hhvm::pgsql
#
# installs hhvm pgsql extension
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::pgsql {
  wget::fetch { 'http://glob.in/pgsql.so':
    destination => '/usr/lib/hhvm/pgsql.so',
    timeout     => 0,
    verbose     => false,
  } ->
  augeas { 'hhvm-add-hdf':
    incl      => '/etc/default/hhvm',
    changes   => [
      'set .anon/ADDITIONAL_ARGS "\'--config /etc/hhvm/server.hdf\'"',
    ],
    load_path => '/usr/share/augeas/lenses/contrib',
    lens      => 'HHVM.lns',
    require   => Class['hhvm::augeas'],
    notify    => Service['hhvm']
  } ->
  augeas { 'hhvm-server-ini-extension':
    incl      => '/etc/hhvm/server.ini',
    changes   => [
      'set .anon/hhvm.dynamic_extension_path /usr/lib/hhvm'
    ],
    load_path => '/usr/share/augeas/lenses/contrib',
    lens      => 'HHVM.lns',
    require   => Class['hhvm::augeas'],
    notify    => Service['hhvm']
  } ->
  file { '/etc/hhvm/server.hdf':
    ensure  => present,
    content => '
DynamicExtensions {
    * = pgsql.so
}
',
    notify  => Service['hhvm']
  }
}
