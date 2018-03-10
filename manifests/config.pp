# @api private
# This class handles the configuration files for beats. Avoid modifying private classes.
class beats::config {
  $beats::beats_manage.each |String $beat| {
    case $facts['os']['family'] {
      'windows': {
        $beat_config = "${beats::config_root}\\${beat}\\${beat}.yml"
      }
      default: {
        $beat_config = "${beats::config_root}/${beat}/${beat}.yml"
      }
    }
    $settings = lookup("beats::${beat}::settings", Data, 'deep', undef)
    if $settings {
      case type($settings) {
        String: {
          file { "${beat}_config":
            ensure => file,
            path   => $beat_config,
            owner  => 0,
            group  => 0,
            mode   => '0600',
            source => $settings,
          }
        }
        default: {
          file { "${beat}_config":
            ensure  => file,
            path    => $beat_config,
            owner   => 0,
            group   => 0,
            mode    => '0600',
            content => epp('beats/beat.yml.epp', { settings => $settings }),
          }
        }
      }
    }
    if $beat == 'metricbeat' {
      require beats::metricbeat::config
    }
  }
}
