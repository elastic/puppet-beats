Puppet::Type.type(:metricbeat_module).provide(:metricbeat) do

    commands :metricbeat => 'metricbeat'

    # Metricbeat module file.
    #
    # @return String
    def module_file
      File.join(
        @resource[:module_dir],
        "#{resource[:name]}.yml"
      )
    end

    def exists?
        if !File.exists?(module_file)
          debug "Module file #{module_file} does not exist"
          return false
        else
          debug "Module exists"
          return true
        end
    end

    def create
        retry_count = 3
        retry_times = 0
        begin
            metricbeat(['modules','enable',resource[:name]])
        rescue Puppet::ExecutionFailure => e
          retry_times += 1
          debug("Failed to enable module. Retrying... #{retry_times} of #{retry_count}")
          sleep 2
          retry if retry_times < retry_count
          raise "Failed to enable module. Received error: #{e.inspect}"
        end
      end

    # Remove this plugin from the host.
    def destroy
        metricbeat(['modules','disable',@resource[:name]])
    end

end
