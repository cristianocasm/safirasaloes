# == Schema Information
#
# Table name: photo_logs
#
#  id              :integer          not null, primary key
#  customer_id     :integer
#  professional_id :integer
#  schedule_id     :integer
#  service_id      :integer
#  safiras         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class PhotoLogTest < ActiveSupport::TestCase
  should belong_to(:customer)
  should belong_to(:professional)
  should belong_to(:schedule)
  should belong_to(:service)
  should have_db_column(:safiras)
end
