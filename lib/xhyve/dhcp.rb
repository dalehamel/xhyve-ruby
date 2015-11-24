module Xhyve
  module DHCP
    LEASES_FILE='/var/db/dhcpd_leases'
    WAIT_TIME=1
    MAX_ATTEMPTS=60

    def self.get_ip_for_mac(mac)
      attempts = 0
      while attempts < MAX_ATTEMPTS
        attempts = attempts +1
        ip = parse_lease_file_for_mac(mac)
        return ip if ip
        sleep(WAIT_TIME)
      end  
    end

    def self.parse_lease_file_for_mac(mac)
      contents = File.read(ENV['LEASES_FILE'] || LEASES_FILE)
      pattern = contents.match(/ip_address=(\S+)\n\thw_address=\d+,#{mac}/)
      if pattern
        addrs = pattern.captures
        addrs.first if addrs
      end
    end
  end
end
