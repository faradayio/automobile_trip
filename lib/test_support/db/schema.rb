require 'sniff/database'

Sniff::Database.define_schema do
  create_table "automobile_trip_records", :force => true do |t|
    t.float  'emission_factor'
    t.float  'fuel_use'
    t.string 'fuel_type_name'
  end
end
