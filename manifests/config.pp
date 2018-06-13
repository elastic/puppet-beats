# @api private
# This class handles the configuration files for beats. Avoid modifying private classes.
class beats::config {
  $beats::managed_beats.each |String $beat| {
    # Generate beat config name
    $beat_config = "${beats::config_root}/${beat}/${beat}.yml"

    # Get beat settings
    $settings = lookup("beats::${beat}::settings", Data, 'deep', undef)

    if $settings {
      # Notify service or not?
      case $beats::service_manage {
        false: {
          $_notify = undef
        }
        default: {
          $_notify = Service[$beat]
        }
      }

      # Set File defaults
      File {
        ensure => file,
        path   => $beat_config,
        owner  => 0,
        group  => 0,
        mode   => '0600',
        notify => $_notify,
      }

      case type($settings) {
        String: {
          file { "${beat}_config":
            source => $settings,
          }
        }
        default: {
          file { "${beat}_config":
            content => epp('beats/beat.yml.epp', { beat => $beat, settings => $settings }),
          }
        }
      }
    }

    if $beat == 'metricbeat' and lookup('beats::metricbeat::modules', Data, 'deep', undef) {
      require beats::metricbeat::config
    }
  }
}
