require 'bundler/setup'

require 'sniff'
Sniff.init File.expand_path('../../..', __FILE__),
  :cucumber => true,
  :logger => false # change this to $stderr to see database activity

require 'geocoder'
class GeocoderWrapper
  def geocode(input, country = 'US')
    if input.is_a?(String)
      input = input + " #{country}"
    else
      input[:country] ||= country
    end
    if res = ::Geocoder.search(input).first
      {
        latitude:  res.coordinates[0],
        longitude: res.coordinates[1],
      }
    end
  end
end
BrighterPlanet::AutomobileTrip.geocoder = GeocoderWrapper.new
