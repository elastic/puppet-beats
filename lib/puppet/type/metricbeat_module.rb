Puppet::Type.newtype(:metricbeat_module) do
    @doc = 'Manage Metricbeat modules'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'An arbitrary name used as the identity of the resource.'
    end

    newparam(:settings) do
        desc 'Any custom settings for this module.'
        validate do |settings|
            unless settings.is_a?(Hash) and settings.to_yaml
                raise ArgumentError , "%s can not be munged to YAML" % settings
            end
        end
    end

    newparam(:module_dir) do
        desc 'Path to the Metricbeat modules directory'
        defaultto '/etc/metricbeat/modules.d'
    end

end
