require 'spec_helper'

describe 'Beats::Managed_beats' do
  describe 'with valid inputs' do
    [ 
      [ 'auditbeat' ],
      [ 'heartbeat' ],
      [ 'metricbeat' ],
      [ 'packetbeat' ],
      [ 'auditbeat', 'heartbeat' ]
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'with invalid inputs' do
    [
      'nonbeat',
      {'auditbeat' => true}
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end

  end
end
