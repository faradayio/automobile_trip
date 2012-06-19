Given /^mapquest determines the distance in miles to be "([^\"]*)"$/ do |distance|
  if distance.present?
    mockquest = mock MapQuestDirections, :status => 0, :xml => "<distance>" + distance.to_s + "</distance>"
  else
    mockquest = mock MapQuestDirections, :status => 601, :xml => "<distance>0</distance>"
  end
  MapQuestDirections.stub!(:new).and_return mockquest
end

Given /^the geocoder will encode the (.*) as "(.*)"$/ do |component, location|
  @expectations << lambda do
    components = @characteristics ? @characteristics : @activity_hash
    component_value = components[component.to_sym].to_s
    code = mock Object, :success => true, :ll => location
    Geokit::Geocoders::MultiGeocoder.stub!(:geocode).with(component_value).and_return code
  end
end

Given /^the geocoder will fail to encode the (.*)$/ do |component|
  @expectations << lambda do
    components = @characteristics ? @characteristics : @activity_hash
    component_value = components[component.to_sym].to_s
    code = mock Object, :success => false
    Geokit::Geocoders::MultiGeocoder.should_receive(:geocode).with(component_value).and_return code
  end
end

When /^(make_model(_year)?) is determined$/ do |characteristic, _|
  result = if @characteristics[:make] and @characteristics[:model]
    if characteristic == 'make_model'
      AutomobileMakeModel.where(:make_name => @characteristics[:make].name, :model_name => @characteristics[:model].name).first
    elsif @characteristics[:year]
      AutomobileMakeModelYear.where(:make_name => @characteristics[:make].name, :model_name => @characteristics[:model].name, :year => @characteristics[:year].year).first
    end
  end
  @characteristics[characteristic.to_sym] = result unless result.nil?
end
