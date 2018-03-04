Puppet::Type.newtype(:metricbeat_module) do
    @doc = 'Manage Metricbeat modules'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'An arbitrary name used as the identity of the resource.'
    end

    newparam(:module_dir) do
        desc 'Path to the Metricbeat modules directory'
        defaultto '/etc/metricbeat/modules.d'
    end

end
