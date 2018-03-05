require 'spec_helper'

describe 'beats::metricbeat::module' do
    let(:pre_condition) { 'include beats' }
    let(:title) { 'redis' }
    let(:params) { {'ensure' => 'present' } }
    on_supported_os.each do |os, facts|
        let(:facts) do
            facts
        end
        context "on #{os}" do
            it { is_expected.to compile }
            it { is_expected.to contain_file('metricbeat_redis_config') }
            it { is_expected.to contain_metricbeat_module('redis') }
        end
    end
end
