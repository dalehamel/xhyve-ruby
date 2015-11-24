require File.expand_path('../../spec_helper.rb', __FILE__)

RSpec.describe Xhyve::Guest do
  let(:kernel) { File.join(FIXTURE_PATH, 'guest', 'vmlinuz') }
  let(:initrd) { File.join(FIXTURE_PATH, 'guest', 'initrd') }
  let(:blockdev) { File.join(FIXTURE_PATH, 'guest', 'loop.img') }
  let(:cmdline) { 'user=console opt=vda tce=vda' }
  let(:guest) { Xhyve::Guest.new(kernel: kernel, initrd: initrd, cmdline: cmdline, blockdevs: blockdev, uuid: TEST_UUID, serial: 'com2') }

  it 'Can start a guest' do
    with_guest(guest) do
      expect(guest.pid).to_not be_nil
      expect(guest.pid).to be > 0
    end
  end

  it 'Can get the MAC of a guest' do
    with_guest(guest) do
      expect(guest.mac).to_not be_nil # probably need to loop inside MAC function for a bit
    end
  end

  it 'Can get the IP of a guest' do
    with_guest(guest) do
      expect(guest.ip).to_not be_nil # probably need to loop inside IP function to ensure has ip
    end
  end

  it 'Can ssh to the guest' do
    with_guest(guest) do
      #expect(guest.ip).to_not be_nil
    end
  end

  it 'Correctly sets memory' do
    with_guest(guest) do
      #expect(guest.ip).to_not be_nil
    end
  end

  it 'Correctly sets processors' do
    with_guest(guest) do
      #expect(guest.ip).to_not be_nil
    end
  end

end
