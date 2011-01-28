Given /^mapquest will return a distance of "(.*)" kilometres$/ do |kms|
  @activity_hash[:mapquest_api_key] = 'ABC123'
  mock_map = mock MapQuestDirections, :distance_in_kilometres => kms.to_f
  MapQuestDirections.stub!(:new).and_return mock_map
end
