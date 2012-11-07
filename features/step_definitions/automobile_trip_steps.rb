require 'rspec/mocks'
RSpec::Mocks.setup self
include RSpec::Mocks::ExampleMethods

Given /^mapquest determines the distance in miles to be "([^\"]*)"$/ do |distance|
  if distance.present?
    mockquest = double MapQuestDirections, :status => 0, :xml => "<distance>" + distance.to_s + "</distance>"
  else
    mockquest = double MapQuestDirections, :status => 601, :xml => "<distance>0</distance>"
  end
  MapQuestDirections.stub!(:new).and_return mockquest
end

Given /^the geocoder will encode the (.*) as "(.*)"$/ do |component, location|
  Geocoder.stub!(:coordinates).and_return location.split(',')
end

Given /^the geocoder will fail to encode the (.*)$/ do |component|
  Geocoder.stub!(:coordinates).and_return nil
end
