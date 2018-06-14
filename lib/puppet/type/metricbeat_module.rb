Puppet::Type.newtype(:metricbeat_module) do
  @doc = 'Manage Metricbeat modules'

  ensurable

  newparam(:name) do
    desc 'An arbitrary name used as the identity of the resource.'
    isnamevar
  end

  newparam(:module_dir) do
    desc 'Path to the Metricbeat modules directory'
    defaultto '/etc/metricbeat/modules.d'
  end
end
