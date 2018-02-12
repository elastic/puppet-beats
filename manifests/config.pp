# @api private
# This class handles the configuration files for beats. Avoid modifying private classes.
class beats::config {
  $beats::beats_manage.each |String $beat| {
    if lookup("beats::${beat}::settings", Data, hash, {}) != {} {
      file { "${beats::config_root}/${beat}/${beat}.yml":
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0600',
        content => inline_epp('<%= lookup("beats::${beat}::settings", {}).to_yaml %>'),
      }
    }
    elsif lookup("beats::${beat}::settings_file", String, unique, '') != '' {
      file { "${beats::config_root}/${beat}/${beat}.yml":
        ensure => file,
        owner  => 0,
        group  => 0,
        mode   => '0600',
        source => lookup("beats::${beat}::settings_file", String, unique),
      }
    }
    if $beat == 'metricbeat' and lookup('metricbeat::modules_enable', Array[String], unique, []) != [] {
      metricbeat::modules_enable.each |String $module| {
        metricbeat_module { $module:
          ensure => 'present'
        }
      }
    }
    if $beat == 'metricbeat' and lookup('metricbeat::modules_disable', Array[String], unique, []) != [] {
      metricbeat_modules_disable.each |String $module| {
        metricbeat_module { $module:
          name   => $module,
          ensure => 'absent'
        }
      }
    }

  }
}
