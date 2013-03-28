require 'earth/automobile/automobile_fuel'
require 'earth/automobile/automobile_make'
require 'earth/automobile/automobile_model'
require 'earth/automobile/automobile_size_class'
require 'earth/automobile/automobile_year'
require 'earth/locality/country'

module BrighterPlanet
  module AutomobileTrip
    module Relationships
      def self.included(target)
        target.belongs_to :make,                :foreign_key => 'make_name',            :class_name => 'AutomobileMake'
        target.belongs_to :model,               :foreign_key => 'model_name',           :class_name => 'AutomobileModel'
        target.belongs_to :year,                :foreign_key => 'year_name',            :class_name => 'AutomobileYear'
        target.belongs_to :size_class,          :foreign_key => 'size_class_name',      :class_name => 'AutomobileSizeClass'
        target.belongs_to :automobile_fuel,     :foreign_key => 'automobile_fuel_name'
        target.belongs_to :country,             :foreign_key => 'country_iso_3166_code'
        target.belongs_to :origin_country,      :foreign_key => 'origin_country_iso_3166_code', :class_name => 'Country'
        target.belongs_to :destination_country, :foreign_key => 'destination_country_iso_3166_code', :class_name => 'Country'
      end
    end
  end
end
