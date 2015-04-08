require 'simplecov'
SimpleCov.start
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/reporters"
require "capybara"
require 'sidekiq/testing'

# # Creates a new thread where thin runs for faye support
# Thread.new do
#   Rack::Handler.
#     get('thin').
#     run(
#       Rack::Builder.parse_file(File.dirname(__FILE__) + '/../private_pub.ru').first,
#       :Port => 9292
#     )
# end

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

  Capybara.register_driver :selenium do |app|
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile.native_events = true
    Capybara::Selenium::Driver.new(app, :browser => :firefox, profile: profile)
  end

  teardown do
    Warden.test_reset!
  end

   #Add more helper methods to be used by all tests here...
end

module MailerMacros
  def last_email
    Sidekiq::Extensions::DelayedMailer.jobs.last
  end
  
  def reset_email
    Sidekiq::Worker.clear_all
  end
end