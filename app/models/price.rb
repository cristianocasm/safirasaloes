# == Schema Information
#
# Table name: prices
#
#  id                    :integer          not null, primary key
#  descricao             :string(255)
#  preco                 :decimal(8, 2)
#  recompensa_divulgacao :integer
#  service_id            :integer
#  created_at            :datetime
#  updated_at            :datetime
#

class Price < ActiveRecord::Base
  validates_presence_of :preco
  # Utilizando gem 'custom_error_message', sempre que o sinal '^' é adicionado
  # ao início da mensagem de erro, então, nome do campo não é colocado no início
  # da mensagem.
  validates_presence_of :descricao, message: I18n.t('price.sem_descricao'), unless: :preco_fixo?
  validates_uniqueness_of :descricao, message: I18n.t('price.descricao_repetida'), scope: :service_id, :case_sensitive => false
  validates_numericality_of :recompensa_divulgacao, message: I18n.t('price.recompensa_deve_ser_positivo_ou_zero'), greater_than_or_equal_to: 0, only_integer: true, allow_nil: true
  validates_numericality_of :preco, message: I18n.t('price.deve_ser_positivo'), greater_than: 0
  
  belongs_to :service
  has_many :schedules

  before_save :set_defaults

  def nome
    preco_fixo? ? self.service.nome : self.service.nome + " (" + self.descricao + ")"
  end

  private

  def preco_fixo?
    self.service.preco_fixo
  end

  def set_defaults
    self.recompensa_divulgacao ||= 0
  end

end