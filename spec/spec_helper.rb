require 'simplecov'
SimpleCov.start

require 'securerandom'
require 'sshkit'
require 'sshkit/dsl'
require 'net/ping'
require File.expand_path('../../lib/xhyve.rb', __FILE__)

FIXTURE_PATH = File.expand_path('../../spec/fixtures', __FILE__)
TEST_UUID = SecureRandom.uuid

#  def self.append_features(mod)
#    mod.class_eval %[
#      around(:each) do |example|
#        example.run
#      end
#    ]
#  end
#end

def ping(ip)
  Net::Ping::ICMP.new(ip).ping
end

def with_guest(guest)
  guest.start
  yield
rescue
  guest.stop
ensure
  guest.stop
  guest.destroy
end

def on_guest(ip, command)
  host = SSHKit::Host.new("console@#{ip}")
  host.password = 'tcuser'
  on host do |host|
    capture(command)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
