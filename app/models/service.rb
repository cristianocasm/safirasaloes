# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  nome            :string(255)
#  preco           :string(255)
#  hora_duracao    :integer
#  minuto_duracao  :integer
#  created_at      :datetime
#  updated_at      :datetime
#  professional_id :integer
#

class Service < ActiveRecord::Base
  has_many :schedules
  belongs_to :professional
end
