require 'yaml'

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

  # Metricbeat module settings.
  #
  # @return String
  def module_settings
    if resource[:settings].empty?
      return ''
    else
      return resource[:settings].to_yaml
    end
  end

  # Write module_settings contents to disk.
  def writemodulefile
    if module_settings
      File.open(module_file, 'w') do |file|
        file.write module_settings
      end
    end
  end

  def exists?
    if !File.exists?(module_file)
      debug "Module file #{module_file} does not exist"
      writemodulefile
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
      writemodulefile
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
