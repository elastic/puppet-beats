# @api private
# This class handles the configuration files for beats. Avoid modifying private classes.
class beats::config {
  $beats::beats_manage.each |String $beat| {
    case $facts['os']['family'] {
      'windows': {
        $beat_config = "${beats::config_root}\${beat}\${beat}.yml"
      }
      default: {
        $beat_config = "${beats::config_root}/${beat}/${beat}.yml"
      }
    }
    if lookup("beats::${beat}::settings", Data, 'deep', undef) {
    case lookup("beats::${beat}::settings") {
      Hash: {
        file { "${beat}_config":
          ensure  => file,
          path    => $beat_config,
          owner   => 0,
          group   => 0,
          mode    => '0600',
          content => inline_epp('<%= lookup("beats::${beat}::settings", Hash, \'deep\').to_yaml %>'),
        }
      }
      String: {
        file { "${beat}_config":
          ensure => file,
          path   => $beat_config,
          owner  => 0,
          group  => 0,
          mode   => '0600',
          source => lookup("beats::${beat}::settings", String),
        }
      }
      Undef: {
        debug "No custom settings for ${beat}, using defaults."
      }
      default: {
        err "Got a data type for beats::${beat}::settings that we didn't expect. Want a Hash or String"
      }
    }
    }
    if $beat == 'metricbeat' and lookup('beats::metricbeat_modules_manage', Hash, 'deep', {}) != {} {
      lookup(beats::metricbeat_modules_manage).each | String $ensure, Array[String] $modules | {
        $modules.each | String $m | {
          if $beats::service_manage == true {
            metricbeat_module { $m:
              ensure   => $ensure,
              settings => lookup("beats::metricbeat::module::settings.${m}", Hash, 'deep', {}),
              notify   => Service['metricbeat']
            }
          }
          else {
            metricbeat_module { $m:
              ensure   => $ensure,
              settings => lookup("beats::metricbeat::module::settings.${m}", Hash, 'deep', {}),
            }
          }
        }
      }
    }
  }
}
