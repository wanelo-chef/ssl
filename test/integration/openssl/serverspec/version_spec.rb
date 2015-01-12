require 'spec_helper'

RSpec.describe 'openssl version' do
  it 'should install the version of openssl specified by attributes' do
    openssl_version = `openssl version`
    expect(openssl_version).to include(node['ssl']['openssl']['version'])
  end
end
