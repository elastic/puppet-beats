require 'spec_helper'

describe 'metricbeat_module' do
  let(:title) { 'apache' }
  let(:name) { 'apache' }

  it { is_expected.to compile }
  it { is_expected.to contain_metricbeat_module('apache') }
end
