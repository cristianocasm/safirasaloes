require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  should belong_to(:professional)
  should belong_to(:customer)
  should have_db_column(:safiras)
end
