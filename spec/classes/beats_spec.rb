require 'spec_helper'

describe 'beats' do
    # defaults should result in all official beats installed
    let(:pre_condition) { %q(
    include elastic_stack::repo
    )}
    on_supported_os.each do |os, facts|
        let(:facts) do
            facts
        end
        context "on #{os}" do
            describe 'beats' do
                it { is_expected.to compile }
                it { is_expected.to contain_class('beats::install') }
                it { is_expected.to contain_class('beats::config') }
                it { is_expected.to contain_class('beats::service') }
            end
            describe 'beats::install' do
                it { is_expected.to contain_package('auditbeat') }
                it { is_expected.to contain_package('heartbeat') }
                it { is_expected.to contain_package('metricbeat') }
                it { is_expected.to contain_package('packetbeat') }
            end
            describe 'beats::service' do
                it { is_expected.to contain_service('auditbeat') }
                it { is_expected.to contain_service('heartbeat') }
                it { is_expected.to contain_service('metricbeat') }
                it { is_expected.to contain_service('packetbeat') }
            end
        end

        # no package management
        context "no package mgmt on #{os}" do
            let(:params) { {'package_manage' => false} }
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
            describe 'beats::service' do
                it { is_expected.to contain_service('auditbeat') }
                it { is_expected.to contain_service('heartbeat') }
                it { is_expected.to contain_service('metricbeat') }
                it { is_expected.to contain_service('packetbeat') }
            end
        end

        # no service management
        context "no service mgmt on #{os}" do
            let(:params) { {'service_manage' => false} }
            describe 'beats' do
                it { is_expected.to compile }
                it { is_expected.to contain_class('beats::install') }
                it { is_expected.to contain_class('beats::config') }
                it { is_expected.to contain_class('beats::service') }
            end
            describe 'beats::install' do
                it { is_expected.to contain_package('auditbeat') }
                it { is_expected.to contain_package('heartbeat') }
                it { is_expected.to contain_package('metricbeat') }
                it { is_expected.to contain_package('packetbeat') }
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
            let(:params) { {'beats_manage' => ['metricbeat']} }
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
            describe 'beats::service' do
                it { is_expected.to contain_service('metricbeat') }
                it { is_expected.not_to contain_service('auditbeat') }
                it { is_expected.not_to contain_service('heartbeat') }
                it { is_expected.not_to contain_service('packetbeat') }
            end
        end
    end
end
