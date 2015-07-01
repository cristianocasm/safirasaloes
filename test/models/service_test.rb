# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  nome            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  professional_id :integer
#  preco_fixo      :boolean          default(TRUE)
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  should have_many(:prices)
  should belong_to(:professional)
  should validate_presence_of(:nome)
  should validate_inclusion_of(:preco_fixo).in_array([true, false])
  should validate_uniqueness_of(:nome).scoped_to(:professional_id)
end
