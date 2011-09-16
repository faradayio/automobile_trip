Given /^mapquest determines the distance in miles to be "([^\"]*)"$/ do |distance|
  mockquest = mock MapQuestDirections, :xml => "<distance>" + distance.to_s + "</distance>"
  MapQuestDirections.stub!(:new).and_return mockquest
end

Given /^the geocoder will encode the (.*) as "(.*)"$/ do |component, location|
  @expectations << lambda do
    components = @characteristics ? @characteristics : @activity_hash
    component_value = components[component.to_sym].to_s
    code = mock Object, :ll => location
    Geokit::Geocoders::MultiGeocoder.should_receive(:geocode).
      with(component_value).
      and_return code
  end
end
