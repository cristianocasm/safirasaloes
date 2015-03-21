require 'test_helper'

class ExchangeOrderTest < ActiveSupport::TestCase
  should belong_to(:schedule)
  should belong_to(:customer)
  should belong_to(:professional)
  should belong_to(:order_status)
end
