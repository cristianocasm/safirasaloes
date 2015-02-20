# == Schema Information
#
# Table name: services
#
#  id             :integer          not null, primary key
#  nome           :string(255)
#  preco          :string(255)
#  hora_duracao   :integer
#  minuto_duracao :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  should have_many(:schedules)
end
