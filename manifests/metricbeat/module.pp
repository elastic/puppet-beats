# @api private
# This defined type handles the enabling/disabling Metricbeat modules. Avoid modifying private defined types.
define beats::metricbeat::module (
  String $ensure = 'present',
  Hash $settings = lookup("beats::metricbeat::module::settings.${name}", Hash, 'deep', {}),
  String $module_dir
)
{
  if $settings != {} {
    metricbeat_module { $name:
      ensure   => $ensure,
    }
    file { "metricbeat_${name}_config":
      ensure  => file,
      path    => "${module_dir}/${name}.yml",
      owner   => 0,
      group   => 0,
      mode    => '0600',
      content => inline_epp('- <%= $name -%>:\n<%= $settings.to_yaml %>'),
    }
  }
  else {
    metricbeat_module { $name:
      ensure   => $ensure
    }
  }
}
