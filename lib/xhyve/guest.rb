require 'securerandom'
require 'pty'

require 'xhyve/dhcp'

module Xhyve
  BINARY_PATH = File.expand_path('../../../lib/xhyve/vendor/xhyve', __FILE__).freeze

  # An object to represent a guest that we can start and stop
  # Effectively, it's a command wrapper around xhyve to provide an
  # object oriented interface to a hypervisor guest
  class Guest
    PCI_BASE = 3

    attr_reader :pid, :uuid, :mac

    def initialize(**opts)
      @kernel = opts.fetch(:kernel)
      @initrd = opts.fetch(:initrd)
      @cmdline = opts.fetch(:cmdline)
      @blockdevs = [opts[:blockdevs] || []].flatten
      @memory = opts[:memory] || '500M'
      @processors = opts[:processors] || '1'
      @uuid = opts[:uuid] || SecureRandom.uuid
      @serial = opts[:serial] || 'com1'
      @acpi = opts[:acpi] || true
      @sudo = opts[:sudo] || true
      @command = build_command
      @mac = VMNet.uuid_to_mac(@uuid)
    end

    def start
      @r, @w, @pid = PTY.getpty(@command.join(' '))
    end

    def stop
      Process.kill('KILL', @pid)
    end

    def running?
      PTY.check(@pid).nil?
    end

    def ip
      @ip ||= Xhyve::DHCP.get_ip_for_mac(@mac)
    end

    private

    def build_command
      [
        "#{'sudo' if @sudo}",
        "#{BINARY_PATH}",
        "#{'-A' if @acpi}",
        '-U', @uuid,
        '-m', @memory,
        '-c', @processors,
        '-s', '0:0,hostbridge',
        '-s', '31,lpc',
        '-l', "#{@serial},stdio",
        '-s', "#{PCI_BASE - 1}:0,virtio-net",
        "#{"#{@blockdevs.each_with_index.map { |p, i| "-s #{PCI_BASE + i},virtio-blk,#{p}" }.join(' ')}" unless @blockdevs.empty? }",
        '-f' "kexec,#{@kernel},#{@initrd},'#{@cmdline}'"
      ].compact
    end
  end
end
