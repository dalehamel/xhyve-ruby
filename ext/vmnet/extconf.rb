require 'mkmf'
require 'rbconfig'

abort 'Only works on OS X' unless RbConfig::CONFIG['host_os'].downcase.include?('darwin')
abort 'missing vmnet.h' unless have_header 'uuid.h'
abort 'missing vmnet.h' unless have_header 'vmnet/vmnet.h'
abort 'missing vmnet' unless have_framework 'vmnet'

create_makefile 'vmnet/vmnet'
