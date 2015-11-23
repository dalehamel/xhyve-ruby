module Xhyve
  module DHCP
    LEASES_FILE='/var/db/dhcpd_leases'
    def get_ip_for_mac(mac)
      contents = File.read(LEASES_FILE)
      addrs = contents.match(/ip_address=(\S+)\n\thw_address=\d+,#{mac}/).captures
      addrs.first if addrs
    end
  end
end
