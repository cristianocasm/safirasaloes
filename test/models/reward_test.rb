# == Schema Information
#
# Table name: rewards
#
#  id              :integer          not null, primary key
#  professional_id :integer
#  customer_id     :integer
#  total_safiras   :integer          default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  photo_id        :integer
#

require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  should belong_to(:professional)
  should belong_to(:customer)
  should have_db_column(:total_safiras)
end
