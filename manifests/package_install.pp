# @api private
# This defined type installs beats packages. Avoid modifying private defined types.
define beats::package_install (
  String $ensure,
  String $package = $name
  ) {
    package { $package:
      ensure => $ensure
    }
  }
