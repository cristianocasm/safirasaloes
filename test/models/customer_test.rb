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
  should have_many(:rewards)
  should have_many(:exchange_orders)
  should have_db_column(:telefone)
end
