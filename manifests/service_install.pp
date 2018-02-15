# @api private
# This defined type installs beats services. Avoid modifying private defined types.
define beats::service_install (
  String $ensure,
  Boolean $enable,
  Optional[String] $provider,
  String $service = $name
) {
  service { $service:
    ensure     => $ensure,
    enable     => $enable,
    provider   => $provider,
    hasstatus  => true,
    hasrestart => true,
  }
}
