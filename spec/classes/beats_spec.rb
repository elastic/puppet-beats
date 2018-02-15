require 'spec_helper'

describe 'beats' do
    let(:params) { {'beats_manage' => ['metricbeat'], 'metricbeat_modules_manage' => { 'ensure' => ['docker']}} }
    it { is_expected.to compile }
    it { is_expected.to contain_class('beats::install') }
    it { is_expected.to contain_class('beats::config') }
    it { is_expected.to contain_class('beats::service') }
    it { is_expected.to contain_beats__package_install('metricbeat') }
    it { is_expected.to contain_beats__service_install('metricbeat') }
end
