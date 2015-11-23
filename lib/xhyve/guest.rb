require 'securerandom'

require 'xhyve/dhcp'

module Xhyve
  BINARY_PATH=File.expand_path('../../../lib/xhyve/vendor/xhyve', __FILE__).freeze
  NETWORK_STR = '-s 2:0,virtio-net'
  PCI_STR = '-s 0:0,hostbridge -s 31,lpc'

  class Guest

    def initialize(**opts)
      @kernel = opts.fetch(:kernel)
      @initrd = opts.fetch(:initrd)
      @cmdline = opts.fetch(:cmdline)
      @memory = opts[:memory] || 1
      @processors = opts[:processors] || 1
      @uuid = opts[:uuid] || SecureRandom.uuid
      @serial = opts[:serial] || 'com1'
      @acpi = opts[:acpi] || true
      @command = build_command
    end

    def start
      spawn(command)
    end

    def get_ip
      Xhyve
    end

    def get_mac
      VMNet.uuid_to_mac(@uuid)
    end

  private
    def build_command
      ["#{BINARY_PATH}",
       "-U #{@uuid}", 
       "-m #{@memory}",
       "-c #{@processors}", 
       "#{NETWORK_STR}",
       "#{PCI_STR}",
       "-l #{@serial},stdio",
       "#{"-A" if @acpi}",
       "-f kexec,#{@kernel},#{@initrd},\"#{@cmdline}\""
      ].join(' ')
    end
  end

  #./build/xhyve -U $UUID -m ${MEM}G -c ${PROCS} -s 2:0,virtio-net -s 0:0,hostbridge -s 31,lpc -l com2,stdio -A -f kexec,/Volumes/CDROM\ 1/BOOT/VMLINUZ,/Volumes/CDROM\ 1/BOOT/INITRD,"boot=live root=/dev/ram0 live-media=initramfs earlyprintk=serial console=ttyS1,115200 net.ifnames=0 biosdevname=0"
end
