require 'spec_helper'

describe 'beats' do

    # defaults should result in all official beats installed
    context 'defaults' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
        it { is_expected.to contain_beats__package_install('auditbeat') }
        it { is_expected.to contain_beats__service_install('auditbeat') }
        it { is_expected.to contain_beats__package_install('heartbeat') }
        it { is_expected.to contain_beats__service_install('heartbeat') }
        it { is_expected.to contain_beats__package_install('metricbeat') }
        it { is_expected.to contain_beats__service_install('metricbeat') }
        it { is_expected.to contain_beats__package_install('packetbeat') }
        it { is_expected.to contain_beats__service_install('packetbeat') }
    end

    # no package management
    context 'defaults (no package mgmt)' do
        let(:params) { {'package_manage' => false} }
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
        it { is_expected.to contain_beats__service_install('auditbeat') }
        it { is_expected.to contain_beats__service_install('heartbeat') }
        it { is_expected.to contain_beats__service_install('metricbeat') }
        it { is_expected.to contain_beats__service_install('packetbeat') }
    end

    # no service management
    context 'defaults (no service mgmt)' do
        let(:params) { {'service_manage' => false} }
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
        it { is_expected.to contain_beats__package_install('auditbeat') }
        it { is_expected.to contain_beats__package_install('heartbeat') }
        it { is_expected.to contain_beats__package_install('metricbeat') }
        it { is_expected.to contain_beats__package_install('packetbeat') }
    end

    # installing a specific beat (metricbeat)
    context 'just metricbeat' do
        let(:params) { {'beats_manage' => ['metricbeat']} }
        it { is_expected.to compile }
        it { is_expected.to contain_class('beats::install') }
        it { is_expected.to contain_class('beats::config') }
        it { is_expected.to contain_class('beats::service') }
        it { is_expected.to contain_beats__package_install('metricbeat') }
        it { is_expected.to contain_beats__service_install('metricbeat') }
    end

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
