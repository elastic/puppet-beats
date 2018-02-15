require 'spec_helper'

describe 'beats' do
    let(:params) { {'beats_manage' => ['metricbeat'], 'metricbeat_modules_manage' => { 'ensure' => ['docker']}} }
    it { is_expected.to compile }
    it { is_expected.to contain_package('metricbeat') }
    it { is_expected.to contain_service('metricbeat') }
end
