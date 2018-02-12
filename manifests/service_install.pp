# @api private
# This defined type installs beats services. Avoid modifying private defined types.
define beats::service_install (
  String[1] $service = $name
) {
  service { $service:
    ensure     => $beats::service_ensure,
    enable     => $beats::service_enable,
    provider   => $beats::service_provider,
    hasstatus  => true,
    hasrestart => true,
  }
}
