# @api private
# This class handles the beats service. Avoid modifying private classes.
class beats::service {
  if $beats::service_manage == true {
    beats::service_install { $beats::beats_manage:
      ensure   => $beats::service_ensure,
      enable   => $beats::service_enable,
      provider => $beats::service_provider
    }
  }
}
