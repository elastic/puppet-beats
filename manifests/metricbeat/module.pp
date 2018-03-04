# @api private
# This defined type handles the enabling/disabling Metricbeat modules. Avoid modifying private defined types.
define beats::metricbeat::module (
  String $ensure = 'present',
  Hash $settings = lookup("beats::metricbeat::module_settings.${name}", Data, 'deep', {}),
  String $module_dir
)
{
  if ! $settings.empty {
    metricbeat_module { $name:
      ensure   => $ensure,
    }
    file { "metricbeat_${name}_config":
      ensure  => file,
      path    => "${module_dir}/${name}.yml",
      owner   => 0,
      group   => 0,
      mode    => '0600',
      content => epp('beats/metricbeat_module.yml.epp', { name => $name, settings => $settings }),
    }
  }
  else {
    metricbeat_module { $name:
      ensure   => $ensure
    }
  }
}
