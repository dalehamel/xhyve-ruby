require_relative 'lib/vmnet/vmnet.bundle'
mac = VMNet.uuid_to_mac("a3f18b73-b040-405d-bdba-e3e77af459be")
puts "Got back #{mac}"
