require 'spec_helper'

describe 'metricbeat_module' do
    let(:title) { 'docker' }
    let(:name) { 'docker' }
    it { is_expected.to compile }
    it { is_expected.to contain_metricbeat_module('docker') }
end
