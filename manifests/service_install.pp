# @api private
# This defined type installs beats services. Avoid modifying private defined types.
define beats::service_install (
  String $ensure,
  Boolean $enable,
  Optional[String] $provider,
  String $beat = $name
) {
  service { $beat:
    ensure     => $ensure,
    enable     => $enable,
    provider   => $provider,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File["${beats::config_root}/${beat}/${beat}.yml"]
  }
}
