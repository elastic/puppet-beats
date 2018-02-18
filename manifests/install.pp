# @api private
# This class handles beats packages. Avoid modifying private classes.
class beats::install {
  if $beats::package_manage {
    package { $beats::beats_manage:
      ensure => $beats::package_ensure
    }
  }
}
