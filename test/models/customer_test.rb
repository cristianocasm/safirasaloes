# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  nome       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  should have_many(:schedules)
end
