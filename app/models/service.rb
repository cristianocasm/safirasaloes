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
  validates_presence_of :nome, :preco
  validates_uniqueness_of :nome, scope: :professional_id, :case_sensitive => false
  validates_numericality_of :recompensa_fidelidade, greater_than_or_equal_to: 0, only_integer: true, allow_nil: true
  validates_numericality_of :recompensa_divulgacao, greater_than_or_equal_to: 0, only_integer: true, allow_nil: true
  validates_numericality_of :preco, greater_than: 0
  
  has_many :schedules
  belongs_to :professional
end
