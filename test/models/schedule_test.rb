# == Schema Information
#
# Table name: schedules
#
#  id              :integer          not null, primary key
#  professional_id :integer
#  customer_id     :integer
#  service_id      :integer
#  hora            :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  should belong_to(:professional)
  should belong_to(:customer)
  should belong_to(:service)
end
