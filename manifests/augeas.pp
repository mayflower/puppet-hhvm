# == Class: hhvm::augeas
#
# hhvm augeas class
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
#  include hhvm::augeas
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::augeas {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  if !defined(File['/usr/share/augeas/lenses/contrib']) {
    file { '/usr/share/augeas/lenses/contrib':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true,
      mode    => '0644',
      owner   => 'root',
      group   => 'root'
    }
  }

  file { '/usr/share/augeas/lenses/contrib/hhvm.aug':
    ensure  => present,
    source  => 'puppet:///modules/hhvm/hhvm.aug',
    require => File['/usr/share/augeas/lenses/contrib']
  }
}
