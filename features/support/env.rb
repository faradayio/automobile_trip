require 'bundler'
Bundler.setup

require 'cucumber'
require 'cucumber/formatter/unicode'
require 'rspec'
require 'rspec/expectations'
require 'cucumber/rspec/doubles'

require 'data_miner'
DataMiner.logger = Logger.new(nil)

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'), :cucumber => true, :earth => [:automobile, :fuel, :locality], :logger => 'log/test_log.txt'

MAPQUEST_KEY = 'ABC123'
