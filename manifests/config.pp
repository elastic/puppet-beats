# @api private
# This class handles the configuration files for beats. Avoid modifying private classes.
class beats::config {
  $beats::beats_manage.each |String $beat| {
    if lookup("beats::${beat}::settings", Data, 'hash', {}) != {} {
      file { "${beats::config_root}/${beat}/${beat}.yml":
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0600',
        content => inline_epp('<%= lookup("beats::${beat}::settings", {}).to_yaml %>'),
      }
    }
    elsif lookup("beats::${beat}::settings", String, unique, '') != '' {
      file { "${beats::config_root}/${beat}/${beat}.yml":
        ensure => file,
        owner  => 0,
        group  => 0,
        mode   => '0600',
        source => lookup("beats::${beat}::settings", String, 'unique'),
      }
    }
    if $beat == 'metricbeat' and lookup('beats::metricbeat_modules_manage', Hash, 'deep', {}) != {} {
      lookup(beats::metricbeat_modules_manage).each | String $ensure, Array[String] $modules | {
        $modules.each | String $m | {
          metricbeat_module { $m:
            ensure   => $ensure,
            settings => lookup("beats::metricbeat::module::settings.${m}", Hash, 'deep', {})
          }
        }
      }
    }
  }
}
