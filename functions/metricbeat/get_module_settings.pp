# beats::metricbeat::get_module_settings
#
# @api private
# This function fetches all of a specific Metricbeat module settings from
# the beats::metricbeat::modules::settings key in Hiera.
# Avoid modifying private classes.
#
# @param module
#   A Metricbeat module to fetch settings for.
#
function beats::metricbeat::get_module_settings(String $module) >> Array[Hash] {
  $module_settings = lookup("beats::metricbeat::modules::settings", Array[Hash], 'deep', undef)
  $settings = $module_settings.filter |$v| {
    $value = $v
    $value =~ Hash and $value[module] == $module
  }
  $settings
}
