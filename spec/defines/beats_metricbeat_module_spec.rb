require 'spec_helper'

describe 'beats::metricbeat::module' do
  let(:pre_condition) { 'include beats' }
  let(:title) { 'redis' }
  let(:params) { { 'ensure' => 'present' } }

  on_supported_os.each do |os, facts|
    let(:facts) do
      facts
    end

    context "on #{os} (without custom settings)" do
      it { is_expected.to compile }
      it { is_expected.not_to contain_file('metricbeat_redis_config') }
      it { is_expected.to contain_metricbeat_module('redis') }
    end
    context "on #{os} (with custom settings)" do
      let(:params) { { 'ensure' => 'present', 'settings' => [{ 'module' => 'redis', 'period' => '20s' }] } }

      it { is_expected.to compile }
      it { is_expected.to contain_file('metricbeat_redis_config') }
      it { is_expected.to contain_metricbeat_module('redis') }
    end
  end
end
