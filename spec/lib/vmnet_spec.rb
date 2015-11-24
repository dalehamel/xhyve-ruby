require File.expand_path('../../spec_helper.rb', __FILE__)

RSpec.describe VMNet do
  it 'generates a mac address from UUID' do
    expect(VMNet.uuid_to_mac(SecureRandom.uuid)).to_not be_empty
  end

  it 'generates the same mac address from the same UUID' do
    uuid = SecureRandom.uuid
    mac = VMNet.uuid_to_mac(uuid)
    expect(VMNet.uuid_to_mac(uuid)).to eq(mac)
  end
end
