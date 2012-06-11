require 'bundler'
Bundler.setup

require 'cucumber'
require 'cucumber/rspec/doubles'

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'),
  # :adapter => 'mysql2',
  # :database => 'test_flight',
  # :username => 'root',
  # :password => 'password',
  :earth => [:automobile, :locality],
  :cucumber => true,
  :logger => 'log/test_log.txt'

MAPQUEST_KEY = 'ABC123'
