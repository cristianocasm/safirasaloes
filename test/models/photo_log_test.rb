require 'test_helper'

class PhotoLogTest < ActiveSupport::TestCase
  should belong_to(:customer)
  should belong_to(:professional)
  should belong_to(:schedule)
  should belong_to(:service)
  should have_db_column(:safiras)
end
