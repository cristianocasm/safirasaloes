require 'test_helper'

class OrderStatusTest < ActiveSupport::TestCase
  should have_many(:exchange_orders)
end
