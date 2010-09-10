require 'sniff/database'

Sniff::Database.define_schema do
  create_table "automobile_trip_records", :force => true do |t|
    t.float 'fuel_use'
  end
end
