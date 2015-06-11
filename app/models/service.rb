# == Schema Information
#
# Table name: services
#
#  id                    :integer          not null, primary key
#  nome                  :string(255)
#  hora_duracao          :integer
#  minuto_duracao        :integer
#  created_at            :datetime
#  updated_at            :datetime
#  professional_id       :integer
#  preco                 :decimal(8, 2)
#  recompensa_divulgacao :integer          default(0)
#

class Service < ActiveRecord::Base
  validates_presence_of :nome, :preco
  validates_uniqueness_of :nome, scope: :professional_id, :case_sensitive => false
  #validates_numericality_of :recompensa_fidelidade, greater_than_or_equal_to: 0, only_integer: true, allow_nil: true
  validates_numericality_of :recompensa_divulgacao, greater_than_or_equal_to: 0, only_integer: true, allow_nil: true
  validates_numericality_of :preco, greater_than: 0
  
  has_many :schedules
  has_many :prices
  accepts_nested_attributes_for :prices, allow_destroy: true

  belongs_to :professional

  before_save :set_defaults
  before_destroy :ensure_future_schedule_inexistence

  private

  def ensure_future_schedule_inexistence
    self.schedules.blank?
  end

  def set_defaults
    self.recompensa_divulgacao ||= 0
  end
end
