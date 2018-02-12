# @api private
# This defined type installs beats packages. Avoid modifying private defined types.
define beats::package_install (
  String[1] $package = $name
  ) {
  package { $package:
      ensure => $beats::package_ensure
  }
}
