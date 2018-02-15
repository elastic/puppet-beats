require 'spec_helper'

describe 'beats::package_install' do
    let(:title) { 'metricbeat' }
    let(:params) { {'package' => 'metricbeat', 'ensure' => 'present' } }

    on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end
          it { is_expected.to compile }
          it { is_expected.to contain_package('metricbeat') }
        end
    end
end
