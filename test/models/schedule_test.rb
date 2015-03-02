# == Schema Information
#
# Table name: schedules
#
#  id                    :integer          not null, primary key
#  professional_id       :integer
#  customer_id           :integer
#  service_id            :integer
#  datahora_inicio       :datetime
#  created_at            :datetime
#  updated_at            :datetime
#  datahora_fim          :datetime
#  recompensa_divulgacao :integer
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  should belong_to(:professional)
  should belong_to(:customer)
  should belong_to(:service)
  should have_db_column(:recompensa_divulgacao)

#---
  should allow_value(1.hour.from_now).for(:datahora_inicio)
  should_not allow_value(1.day.ago).for(:datahora_inicio)
  should allow_value(1.days.from_now).for(:datahora_fim)
  should_not allow_value(1.day.ago).for(:datahora_fim)

  should validate_presence_of(:datahora_inicio)
end

# == Plano de Teste para Schedules
#   Cliente
#     - Marcação de Horário
#       - Cliente cadastrado?
#         - Não envia e-mail
#       - Cliente não cadastrado?
#         - Recompensa de fidelidade para o serviço?
#           - E-mail de convite falando sobre o que ele ganhou
#         - Sem recompensa de fidelidade?
#           - Recompensa de Divulgação?
#             - E-mail de convite alertando sobre Safira de Divulgação
#           - Sem recompensa de Divulgação?
#             - Não envia e-mail

#---
#   - Nome, email e telefone na seleção de cliente (todos com autopreenchimento e, quando selecionado o cliente, demais campos são preenchidos)
#   - Cliente não informado exibe mensagem de erro
#   - Seleção de cliente e Seleção de outro deve alterar informações do formulário corretamente
# Service
#   - Serviço não informado retorna mensagem de erro correta
#   - datahora_inicio não informada retorna mensagem de erro correta
#   - datahora_fim não informada retorna mensagem de erro correta
#   - datahora_fim deve ser igual ou superior à datahora_inicio
#   - datahora_inicio deve ser igual ou superior a hoje
