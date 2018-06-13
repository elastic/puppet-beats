# beats
#
# @param config_root
#   The root directory under which individual beats config directories are found. Default value: '/etc'.
#
# @param manage_repo
#   Enable repository management. Configure the official repositories.
#
# @param managed_beats
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
class beats (
  String                     $config_root,
  Boolean                    $manage_repo,
  Beats::Managed_beats       $managed_beats,
  Variant[Enum['present', 'absent', 'latest'], Pattern[/^\d([.]\d+)*(-[\d\w]+)?$/]] $package_ensure,
  Boolean                    $package_manage,
  Boolean                    $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  Boolean                    $service_manage,
  ) {

  contain beats::install
  contain beats::config
  contain beats::service

  if $manage_repo {
    include elastic_stack::repo
    Class['elastic_stack::repo'] -> Class['beats::install']
  }

  # Absent needs to run classes in a different order
  case $package_ensure {
    'absent': {
      Class['::beats::service']
      -> Class['::beats::config']
      -> Class['::beats::install']
    }
    default: {
      Class['::beats::install']
      -> Class['::beats::config']
      -> Class['::beats::service']
    }
  }
}

