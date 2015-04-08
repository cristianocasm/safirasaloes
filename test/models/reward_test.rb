# == Schema Information
#
# Table name: rewards
#
#  id              :integer          not null, primary key
#  professional_id :integer
#  customer_id     :integer
#  total_safiras   :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  should belong_to(:professional)
  should belong_to(:customer)
  should have_db_column(:total_safiras)
end
