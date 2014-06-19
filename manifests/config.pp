# == Class: hhvm::config
#
# configure hhvm
#
# === Parameters
#
# No parameters
#
# === Variables
#
# No variables
#
# === Examples
#
#  include hhvm::config
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::config (
  $user     = 'www-data',
  $group    = 'www-data',
  $port     = 9000,
  $settings = []
) {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  include hhvm::augeas

  augeas { 'hhvm-default-config':
    incl      => '/etc/default/hhvm',
    changes   => [
      "set .anon/RUN_AS_USER \"${user}\"",
      "set .anon/RUN_AS_GROUP \"${group}\"",
    ],
    load_path => '/usr/share/augeas/lenses/contrib',
    lens      => 'HHVM.lns',
    require   => Class['hhvm::augeas'],
    notify    => Service['hhvm']
  }

  augeas { 'hhvm-server-ini':
    incl      => '/etc/hhvm/server.ini',
    changes   => [
      "set .anon/hhvm.server.port ${port}"
    ],
    load_path => '/usr/share/augeas/lenses/contrib',
    lens      => 'HHVM.lns',
    require   => Class['hhvm::augeas'],
    notify    => Service['hhvm']
  }

  augeas { 'hhvm-php-ini':
    incl      => '/etc/hhvm/php.ini',
    changes   => $settings,
    load_path => '/usr/share/augeas/lenses/contrib',
    lens      => 'HHVM.lns',
    require   => Class['hhvm::augeas'],
    notify    => Service['hhvm']
  }
}
