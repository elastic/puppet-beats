require 'spec_helper'

describe 'beats::service_install' do
    let(:title) { 'metricbeat' }
    let(:params) { {'ensure' => 'running', 'enable' => true, 'provider' => :undef } }
    on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end
          it { is_expected.to compile }
          it { is_expected.to contain_service('metricbeat') }
        end
    end
end
