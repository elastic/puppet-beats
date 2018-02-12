# @api private
# This class handles the beats service. Avoid modifying private classes.
class beats::service {
  if $beats::service_manage == true {
    beats::service_install { $beats::beats_manage: }
  }
}
