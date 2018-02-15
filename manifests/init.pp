# beats
#
# @param beats_manage
#   The names of Beats to manage with this module.
#
# @param package_ensure
#   Whether to install Beats packages, and what version to install. Values: 'present', 'latest', or a specific version number.
#   Default value: 'present'.
#
# @param package_manage
#   Whether to manage the Beats packages. Default value: true.
#
# @param service_enable
#   Whether to enable the Beats services at boot. Default value: true.
#
# @param service_ensure
#   Whether the Beats services should be running. Default value: 'running'.
#
# @param service_manage
#   Whether to manage the Beats services.  Default value: true.
#
# @param service_provider
#   Which service provider to use for Beats. Default value: 'undef'.
#
# @param config_root
#   The root directory under which individual beats config directories are found. Default value: '/etc'.
#
# @param metricbeat_modules_manage
#   A list of Metricbeat modules to manage Default value: 'undef'.
#
class beats (
  Array[String] $beats_manage,
  String $package_ensure,
  Boolean $package_manage,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  Boolean $service_manage,
  Optional[String] $service_provider,
  String $config_root,
  Optional[Hash] $metricbeat_modules_manage
  ) {
    contain beats::install
    contain beats::config
    contain beats::service

    Class['::beats::install']
    -> Class['::beats::config']
    ~> Class['::beats::service']
}
