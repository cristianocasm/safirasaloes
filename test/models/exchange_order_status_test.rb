require 'test_helper'

class ExchangeOrderStatusTest < ActiveSupport::TestCase
  should have_many(:schedules)
end
