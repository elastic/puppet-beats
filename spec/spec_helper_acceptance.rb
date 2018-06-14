require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

ENV['PUPPET_INSTALL_TYPE'] = 'agent' if ENV['PUPPET_INSTALL_TYPE'].nil?

run_puppet_install_helper
install_module
install_module_dependencies

# Install aditional modules for soft deps
install_module_from_forge('puppetlabs-apt', '>= 4.1.0 < 5.0.0') if fact('os.family') == 'Debian'
install_module_from_forge('darin/zypprepo', '>= 1.0.0 < 2.0.0') if fact('os.family') == 'Suse'

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
end

shared_examples 'an idempotent resource' do
  it 'applies with no errors' do
    apply_manifest(manifest, catch_failures: true)
  end

  it 'applies a second time without changes' do
    apply_manifest(manifest, catch_changes: true)
  end
end
