ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require 'capybara/rails'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include Capybara::DSL

  # Add more helper methods to be used by all tests here...
  reporter_options = { color: true, slow_count: 5 }
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def run_browser
    Selenium::WebDriver::Firefox::Binary.path='/home/cristiano/firefox/firefox'
    Capybara.current_driver = :selenium
    skip("Evitando JS") if ENV["js"] == "false"
  end

end