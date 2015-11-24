module Xhyve
  module DHCP
    LEASES_FILE='/var/db/dhcpd_leases'
    def self.get_ip_for_mac(mac)
      contents = File.read(ENV['LEASES_FILE'] || LEASES_FILE)
      pattern = contents.match(/ip_address=(\S+)\n\thw_address=\d+,#{mac}/)
      if pattern
        addrs = pattern.captures
        addrs.first if addrs
      end
    end
  end
end
