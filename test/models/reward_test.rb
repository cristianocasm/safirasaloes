# == Schema Information
#
# Table name: rewards
#
#  id                 :integer          not null, primary key
#  service_id         :integer
#  quantidade_safiras :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  should belong_to(:service)
end
