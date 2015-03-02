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
#  recompensa_divulgacao :integer
#  recompensa_fidelidade :integer
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  should have_many(:schedules)
  should belong_to(:professional)
  should validate_presence_of(:nome)
  should validate_uniqueness_of(:nome).scoped_to(:professional_id)
  should validate_presence_of(:preco)
  should validate_numericality_of(:preco).is_greater_than(0)
  should validate_numericality_of(:recompensa_fidelidade).only_integer.is_greater_than_or_equal_to(0).allow_nil
  should validate_numericality_of(:recompensa_divulgacao).only_integer.is_greater_than_or_equal_to(0).allow_nil
end

# == Plano de Teste para Serviços
# Index
#   OK Deleção apresenta mensagem correta
# Create
#   OK Criação com sucesso apresenta mensagem correta
#   OK Criação com sucesso para nomes repetidos, porém de profissionais distintos
#   OK Criação com erros apresentam mensagens corretas
#     OK - Nome não informado
#     OK - Preço não informado
#     OK - Nome já existente (mesmo usuário)

#     OK - Preço negativo
#     OK - Preço zerado
#     OK - Preço com texto

#     OK - Recompensa Fidelidade negativo
#     OK - Recompensa Fidelidade zerado
#     OK - Recompensa Fidelidade com texto
#     OK - Recompensa Fidelidade com float

#     OK - Recompensa Divulgação negativo
#     OK - Recompensa Divulgação zerado
#     OK - Recompensa Divulgação com texto
#     OK - Recompensa Divulgação com float

# Atualização
#   OK - Atualização com sucesso apresenta mensagem correta
#   OK - Atualização com erros apresentam mensagens corretas
#     OK - Nome não informado
#     OK - Preço não informado
#     OK - Nome já existente (mesmo usuário)

#     OK - Preço negativo
#     OK - Preço zerado
#     OK - Preço com texto

#     OK - Recompensa Fidelidade negativo
#     OK - Recompensa Fidelidade zerado
#     OK - Recompensa Fidelidade com texto
#     OK - Recompensa Fidelidade com float

#     OK - Recompensa Divulgação negativo
#     OK - Recompensa Divulgação zerado
#     OK - Recompensa Divulgação com texto
#     OK - Recompensa Divulgação com float
