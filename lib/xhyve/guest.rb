require 'securerandom'

require 'xhyve/dhcp'

module Xhyve
  BINARY_PATH=File.expand_path('../../../lib/xhyve/vendor/xhyve', __FILE__).freeze

  class Guest
    PCI_STR = '-s 0:0,hostbridge'
    PCI_BASE = 3
    NETWORK_STR = "-s #{PCI_BASE-1}:0,virtio-net"

    attr_reader :pid, :uuid

    def initialize(**opts)
      @kernel = opts.fetch(:kernel)
      @initrd = opts.fetch(:initrd)
      @cmdline = opts.fetch(:cmdline)
      @blockdevs = [ opts[:blockdevs] || [] ].flatten
      @memory = opts[:memory] || '500M'
      @processors = opts[:processors] || 1
      @uuid = opts[:uuid] || SecureRandom.uuid
      @serial = opts[:serial] || 'com1'
      @acpi = opts[:acpi] || true
      @sudo = opts[:sudo] || true
      @command = build_command
    end

    def start
      @pid = spawn(@command)
    end

    def stop
      Process.kill('TERM', @pid) if running?
    end

    def destroy
      Process.kill('KILL', @pid) if running?
    end

    def running?
      Process.kill(0, @pid)
    rescue Errno::ESRCH
      false
    end
    
    def ip
      @ip ||= Xhyve::DHCP.get_ip_for_mac(get_mac)
    end

    def mac
      @mac ||= VMNet.uuid_to_mac(@uuid)
    end

  private
    def build_command
      [
       "#{"sudo" if @sudo}",
       "#{BINARY_PATH}",
       "#{"-A" if @acpi}",
       "-U #{@uuid}", 
       "-m #{@memory}",
       "-c #{@processors}", 
       "#{PCI_STR}",
       '-s 31,lpc',
       "-l #{@serial},stdio",
       "#{NETWORK_STR}",
       "#{"#{@blockdevs.each_with_index.map{ |p,i| "-s #{PCI_BASE+i},virtio-blk,#{p}" }.join(' ')}" unless @blockdevs.empty? }",
       "-f kexec,#{@kernel},#{@initrd},'#{@cmdline}'"
      ].join(' ')
    end
  end

  #./build/xhyve -U $UUID -m ${MEM}G -c ${PROCS} -s 2:0,virtio-net -s 0:0,hostbridge -s 31,lpc -l com2,stdio -A -f kexec,/Volumes/CDROM\ 1/BOOT/VMLINUZ,/Volumes/CDROM\ 1/BOOT/INITRD,"boot=live root=/dev/ram0 live-media=initramfs earlyprintk=serial console=ttyS1,115200 net.ifnames=0 biosdevname=0"
end
