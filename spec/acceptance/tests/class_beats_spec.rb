require 'spec_helper_acceptance'

describe 'beats class' do
  let(:manifest) do
    <<-MANIFEST
      class { 'beats': }
    MANIFEST
  end

  it_behaves_like 'an idempotent resource'
end
