# @api private
# This class handles the beats service. Avoid modifying private classes.
class beats::service {
  if $beats::service_manage {

    $beats::managed_beats.each |String $beat| {
      service { $beat:
        ensure     => $beats::service_ensure,
        enable     => $beats::service_enable,
        hasstatus  => true,
        hasrestart => true,
      }
    }
  }
}
