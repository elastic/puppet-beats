# beats::metricbeat::config
#
# @param modules_manage
#   A list of Metricbeat modules to manage. Default value: 'undef'.
#
# @api private
# This class handles the configuration files for beats. Avoid modifying private classes.
class beats::metricbeat::config (
  Hash $modules_manage = lookup('beats::metricbeat::modules', Hash, 'deep')
){
  if $modules_manage {
    $modules_manage.each | String $ensure, Array[String] $modules | {
      $modules.each | $module | {
        $settings = beats::metricbeat::get_module_settings($module)
        if $beats::service_manage == true {
          beats::metricbeat::module { $module:
            ensure   => $ensure,
            settings => $settings,
            notify   => Service['metricbeat']
          }
        }
        else {
          beats::metricbeat::module { $module:
            ensure   => $ensure,
            settings => $settings
          }
        }
      }
    }
  }
}
