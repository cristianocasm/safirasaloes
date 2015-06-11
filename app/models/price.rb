class Price < ActiveRecord::Base
  validates_presence_of :nome, :preco
  validates_uniqueness_of :nome, scope: :service_id, :case_sensitive => false
  validates_numericality_of :recompensa_divulgacao, greater_than_or_equal_to: 0, only_integer: true, allow_nil: true
  validates_numericality_of :preco, greater_than: 0
  
  belongs_to :service
end
