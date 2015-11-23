require "mkmf"

require 'rbconfig'

def host_os
  os = RbConfig::CONFIG['host_os']
  case
  when os.downcase.include?('linux')
    'linux'
  when os.downcase.include?('darwin')
    'darwin'
  else
    puts 'You are not on a supported platform. exiting...'
    puts 'Mac OS X and Linux are the only supported platforms.'
    exit
  end
end

abort "missing vmnet.h" unless have_header "uuid.h"
abort "missing vmnet.h" unless have_header "vmnet/vmnet.h"

if host_os == 'darwin'
  abort "missing vmnet" unless have_framework "vmnet"
else
  abort "missing vmnet" unless have_library "vmnet"
end

create_makefile "vmnet/vmnet"
