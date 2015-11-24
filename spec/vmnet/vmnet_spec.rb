require File.expand_path('../../spec_helper.rb', __FILE__)

RSpec.describe VMNet do

  it 'generates a mac address from UUID' do
    expect(VMNet.uuid_to_mac(TEST_UUID)).to_not be_empty
  end

end
