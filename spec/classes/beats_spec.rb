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
        context "defaults on #{os}" do
            it { is_expected.to compile }
            it { is_expected.to contain_class('beats::install') }
            it { is_expected.to contain_class('beats::config') }
            it { is_expected.to contain_class('beats::service') }
            it { is_expected.to contain_package('auditbeat') }
            it { is_expected.to contain_package('heartbeat') }
            it { is_expected.to contain_package('metricbeat') }
            it { is_expected.to contain_package('packetbeat') }
            it { is_expected.to contain_service('auditbeat') }
            it { is_expected.to contain_service('heartbeat') }
            it { is_expected.to contain_service('metricbeat') }
            it { is_expected.to contain_service('packetbeat') }
        end

        # no package management
        context "defaults (no package mgmt) on #{os}" do
            let(:params) { {'package_manage' => false} }
            it { is_expected.to compile }
            it { is_expected.to contain_class('beats::install') }
            it { is_expected.to contain_class('beats::config') }
            it { is_expected.to contain_class('beats::service') }
            it { is_expected.to contain_service('auditbeat') }
            it { is_expected.to contain_service('heartbeat') }
            it { is_expected.to contain_service('metricbeat') }
            it { is_expected.to contain_service('packetbeat') }
        end

        # no service management
        context "defaults (no service mgmt) on #{os}" do
            let(:params) { {'service_manage' => false} }
            it { is_expected.to compile }
            it { is_expected.to contain_class('beats::install') }
            it { is_expected.to contain_class('beats::config') }
            it { is_expected.to contain_class('beats::service') }
            it { is_expected.to contain_package('auditbeat') }
            it { is_expected.to contain_package('heartbeat') }
            it { is_expected.to contain_package('metricbeat') }
            it { is_expected.to contain_package('packetbeat') }
        end

        # installing a specific beat (metricbeat)
        context "just metricbeat on #{os}" do
            let(:params) { {'beats_manage' => ['metricbeat']} }
            it { is_expected.to compile }
            it { is_expected.to contain_class('beats::install') }
            it { is_expected.to contain_class('beats::config') }
            it { is_expected.to contain_class('beats::service') }
            it { is_expected.to contain_package('metricbeat') }
            it { is_expected.to contain_service('metricbeat') }
        end

        # context 'auditbeat with a config file' do
        #     let(:params) { {'beats_manage' => ['auditbeat']} }
        #     let(:pre_condition) { '${beats::auditbeat::settings} = \'puppet:///some/path/to/auditbeat.yml\'' }
        #     it { is_expected.to compile }
        #     it { is_expected.to contain_class('beats::install') }
        #     it { is_expected.to contain_class('beats::config') }
        #     it { is_expected.to contain_class('beats::service') }
        #     it { is_expected.to contain_package('auditbeat') }
        #     it { is_expected.to contain_service('auditbeat') }
        # end
        # installing a specific beat with certain modules enabled/disabled
        # context 'metricbeat with modules' do
        #     let(:params) { {'beats_manage' => ['metricbeat'], 'metricbeat_modules_manage' => { 'enable' => ['docker']}} }
        #     it { is_expected.to compile }
        #     it { is_expected.to contain_class('beats::install') }
        #     it { is_expected.to contain_class('beats::config') }
        #     it { is_expected.to contain_class('beats::service') }
        #     it { is_expected.to contain_beats__package_install('metricbeat') }
        #     it { is_expected.to contain_beats__service_install('metricbeat') }
        #     it { is_expected.to contain_metricbeat_module('docker') }
        # end
    end
end
