require 'spec_helper'

describe 'beats' do
  # defaults should result in all official beats installed
  on_supported_os.each do |os, facts|
    let(:facts) do
      facts
    end

    context "on #{os}" do
      describe 'beats' do
        it { is_expected.to compile }
        it {
          is_expected.to contain_class('beats::install')
            .that_requires('class[elastic_stack::repo]')
        }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
      end
      describe 'beats::install' do
        it { is_expected.to contain_package('auditbeat') }
        it { is_expected.to contain_package('heartbeat') }
        it { is_expected.to contain_package('metricbeat') }
        it { is_expected.to contain_package('packetbeat') }
      end
      describe 'beats::config' do
        it { is_expected.to contain_file('auditbeat_config') }
        it { is_expected.to contain_class('beats::metricbeat::config') }
      end
      describe 'beats::metricbeat::config' do
        it { is_expected.to contain_beats__metricbeat__module('docker').that_notifies('Service[metricbeat]') }
        it { is_expected.to contain_metricbeat_module('docker') }
        it { is_expected.to contain_file('metricbeat_docker_config') }
      end
      describe 'beats::service' do
        it { is_expected.to contain_file('auditbeat_config') }
        it { is_expected.to contain_service('auditbeat').that_subscribes_to('File[auditbeat_config]') }
        it { is_expected.to contain_service('heartbeat') }
        it { is_expected.to contain_service('metricbeat') }
        it { is_expected.to contain_service('packetbeat') }
      end
    end

    # no package management
    context "no package mgmt on #{os}" do
      let(:params) { { 'package_manage' => false } }

      describe 'beats' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
      end
      describe 'beats::install' do
        it { is_expected.not_to contain_package('auditbeat') }
        it { is_expected.not_to contain_package('heartbeat') }
        it { is_expected.not_to contain_package('metricbeat') }
        it { is_expected.not_to contain_package('packetbeat') }
      end
    end

    # no repo management
    context "no repo mgmt on #{os}" do
      let(:params) { { 'manage_repo' => false } }

      describe 'beats' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }

        it { is_expected.not_to contain_class('elastic_stack::repo') }
      end
    end

    # no service management
    context "no service mgmt on #{os}" do
      let(:params) { { 'service_manage' => false } }

      describe 'beats' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
      end
      describe 'beats::service' do
        it { is_expected.not_to contain_service('auditbeat') }
        it { is_expected.not_to contain_service('heartbeat') }
        it { is_expected.not_to contain_service('metricbeat') }
        it { is_expected.not_to contain_service('packetbeat') }
      end
    end

    # installing a specific beat (metricbeat)
    context "just metricbeat on #{os}" do
      let(:params) { { 'managed_beats' => ['metricbeat'] } }

      describe 'beats' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
      end
      describe 'beats::install' do
        it { is_expected.to contain_package('metricbeat') }
        it { is_expected.not_to contain_package('auditbeat') }
        it { is_expected.not_to contain_package('heartbeat') }
        it { is_expected.not_to contain_package('packetbeat') }
      end
      describe 'beats::config' do
        it { is_expected.not_to contain_file('auditbeat_config') }
        it { is_expected.to contain_class('beats::metricbeat::config') }
      end
      describe 'beats::service' do
        it { is_expected.to contain_service('metricbeat') }
        it { is_expected.not_to contain_service('auditbeat') }
        it { is_expected.not_to contain_service('heartbeat') }
        it { is_expected.not_to contain_service('packetbeat') }
      end
    end
  end
end
