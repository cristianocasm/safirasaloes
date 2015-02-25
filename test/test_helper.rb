ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/reporters"

class ActiveSupport::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  ActiveRecord::Migration.check_pending!

    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  reporter_options = { color: true, slow_count: 5 }
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
  # Selenium::WebDriver::Firefox::Binary.path='/home/cristiano/firefox/firefox'
  # Capybara.current_driver = :selenium

   #Add more helper methods to be used by all tests here...
end
