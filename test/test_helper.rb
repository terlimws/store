require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def deny(condition)
    # a simple transformation to increase readability IMO
    assert !condition
  end
  
  def setup
    GeoKit::Geocoders::MultiGeocoder.stubs(:geocode).raises(RuntimeError,
      'Use mock_geocoding_success! or mock_geocoding_failure! in your test')
  end

  def mock_geocoding_success!
    geocode_payload = GeoKit::GeoLoc.new(:lat => 123.456, :lng => 123.456)
    geocode_payload.success = true
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).returns(geocode_payload)
  end

  def mock_geocoding_failure!
    geocode_payload = GeoKit::GeoLoc.new
    geocode_payload.success = false
    GeoKit::Geocoders::MultiGeocoder.expects(:geocode).returns(geocode_payload)
  end
  
  
  
end
