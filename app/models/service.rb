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
  validates_inclusion_of :preco_fixo, :in => [true, false]
  validates_uniqueness_of :nome, scope: :professional_id, :case_sensitive => false
  validate :at_least_two_prices_on_multiple_prices
  validate :uniqueness_of_descricao
  
  belongs_to :professional
  has_many :schedules
  
  # callback 'before_destroy' TEM que estar definido antes
  # de has_many :prices para que ensure_future_schedule_inexistence
  # seja chamado antes da deleção dos preços
  before_destroy :ensure_future_schedule_inexistence
  has_many :prices, :inverse_of => :service, dependent: :destroy
  accepts_nested_attributes_for :prices, allow_destroy: true
  
  before_update :delete_old_prices, if: :preco_fixo_changed?

  def prices_ordered
    self.prices.order(created_at: :asc)
  end

  private

  def ensure_future_schedule_inexistence
    !self.prices.any? { |pr| pr.schedules.present? }
  end

  # Quando preço do serviço é variável, valida se
  # pelo menos 2 preços foram informados
  def at_least_two_prices_on_multiple_prices
    if !self.preco_fixo && count_services_prices < 2
      self.errors.add(:base, I18n.t('servico.com_preco_variavel.deve_ter_pelo_menos_2_precos'))
    end
  end

  def uniqueness_of_descricao
    unless self.preco_fixo
      descs = self.prices.map(&:descricao)
      self.errors.add('prices.preco', I18n.t('price.descricao_repetida')) if descs.uniq.length < descs.length
    end
  end

  def delete_old_prices
    if ensure_future_schedule_inexistence
      self.prices.each { |pr| pr.destroy if pr.persisted? }
    else
      tipo_preco = self.preco_fixo ? 'Fixo' : 'Variável'
      self.errors.add('prices.preco', I18n.t('price.com_horario_marcado', tipo_preco: tipo_preco))
      false
    end
  end

  # Calcula quantos preços o serviço possui. Lógica é dada
  # pela diferença entre o número de preços persistidos e
  # o número de preços marcados para deleção
  def count_services_prices
    self.prices.length - count_marked_for_destruction
  end

  def count_marked_for_destruction
    self.prices.to_a.count { |pr| pr.marked_for_destruction? }
  end

end
