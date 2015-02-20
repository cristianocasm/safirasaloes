# == Schema Information
#
# Table name: statuses
#
#  id            :integer          not null, primary key
#  nome          :string(255)
#  descricao     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  dias_vigencia :integer
#

require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  should have_many(:professionals)
end
