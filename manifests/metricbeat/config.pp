# beats::metricbeat::config
#
# @param modules_manage
#   A list of Metricbeat modules to manage. Default value: 'undef'.
#
# @api private
# This class handles the configuration files for beats. Avoid modifying private classes.
class beats::metricbeat::config (
  Optional[Hash] $modules_manage = lookup('beats::metricbeat::modules', Hash, 'deep', undef)
){
  if $modules_manage {
    $modules_manage.each | String $ensure, Array[String] $modules | {
        if $beats::service_manage == true {
          beats::metricbeat::module { $modules:
            ensure => $ensure,
            notify => Service['metricbeat']
          }
        }
        else {
          beats::metricbeat::module { $modules:
            ensure => $ensure,
          }
        }
      }
    }
  }
