module Xhyve
  module DHCP
    LEASES_FILE = '/var/db/dhcpd_leases'
    WAIT_TIME = 1
    MAX_ATTEMPTS = 60

    def self.get_ip_for_mac(mac)
      attempts = 0
      max_attempts = ENV.has_key?('MAX_IP_WAIT') ? ENV['MAX_IP_WAIT'].to_i : MAX_ATTEMPTS
      while attempts < max_attempts
        attempts += 1
        ip = parse_lease_file_for_mac(mac)
        return ip if ip
        sleep(WAIT_TIME)
      end
    end

    def self.parse_lease_file_for_mac(mac)
      lease_file = (ENV['LEASES_FILE'] || LEASES_FILE)
      contents = File.read(lease_file)
      pattern = contents.match(/ip_address=(\S+)\n\thw_address=\d+,#{mac}/)
      if pattern
        addrs = pattern.captures
        addrs.first if addrs
      end
    end
  end
end
