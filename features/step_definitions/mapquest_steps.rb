Given /^mapquest will return a distance of "(.*)" kilometres$/ do |kms|
  mock_map = mock MapQuestDirections, :distance_in_kilometres => kms.to_f
  MapQuestDirections.stub!(:new).and_return mock_map
end
