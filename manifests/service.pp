# @api private
# This class handles the beats service. Avoid modifying private classes.
class beats::service {
  if $beats::service_manage == true {
    $beats::beats_manage.each |String $beat| {
      if getvar("beats::${beat}::settings") {
        service { $beat:
          ensure     => $beats::service_ensure,
          enable     => $beats::service_enable,
          provider   => $beats::service_provider,
          hasstatus  => true,
          hasrestart => true,
          subscribe  => File["${beat}_config"]
        }
      }
      else {
        service { $beat:
          ensure     => $beats::service_ensure,
          enable     => $beats::service_enable,
          provider   => $beats::service_provider,
          hasstatus  => true,
          hasrestart => true,
        }
      }
    }
  }
}
