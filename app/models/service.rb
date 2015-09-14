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

class Service < ActiveRecord::Base
  validates_presence_of :nome
  validates_presence_of :professional
  validates_inclusion_of :preco_fixo, :in => [true, false]
  validates_uniqueness_of :nome, scope: :professional_id, :case_sensitive => false
  validate :uniqueness_of_descricao
  
  belongs_to :professional
  
  # callback 'before_destroy' TEM que estar definido antes
  # de has_many :prices para que ensure_future_schedule_inexistence
  # seja chamado antes da deleção dos preços
  before_destroy :ensure_future_schedule_inexistence
  has_many :prices, inverse_of: :service, dependent: :destroy
  accepts_nested_attributes_for :prices, allow_destroy: true

  def prices_ordered
    self.prices.order(created_at: :asc)
  end

  private

  def ensure_future_schedule_inexistence
    !self.prices.any? { |pr| pr.schedules.present? }
  end

  def uniqueness_of_descricao
    unless self.preco_fixo
      descs = self.prices.map(&:descricao)
      self.errors.add('prices.preco', I18n.t('price.descricao_repetida')) if descs.uniq.length < descs.length
    end
  end

end
