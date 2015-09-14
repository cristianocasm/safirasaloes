# == Schema Information
#
# Table name: taken_steps
#
#  id                              :integer          not null, primary key
#  professional_id                 :integer
#  tela_cadastro_contato_acessada  :boolean          default(FALSE)
#  contato_cadastrado              :boolean          default(FALSE)
#  tela_cadastro_servico_acessada  :boolean          default(FALSE)
#  servico_cadastrado              :boolean          default(FALSE)
#  tela_cadastro_horario_acessada  :boolean          default(FALSE)
#  horario_cadastrado              :boolean          default(FALSE)
#  created_at                      :datetime
#  updated_at                      :datetime
#  tela_listagem_servicos_acessada :boolean          default(FALSE)
#  tela_edicao_servico_acessada    :boolean          default(FALSE)
#

require 'test_helper'

class TakenStepTest < ActiveSupport::TestCase
  should have_db_column :tela_cadastro_contato_acessada
  should have_db_column :contato_cadastrado
  should have_db_column :tela_cadastro_servico_acessada
  should have_db_column :servico_cadastrado
  should have_db_column :tela_cadastro_horario_acessada
  should have_db_column :horario_cadastrado
  should belong_to :professional

  test "define todos os passos como 'false' (não realizados)" do
    steps = Professional.create(email: 'email_test@test.com', password: '123456').taken_step
    assert_not steps.tela_cadastro_contato_acessada
    assert_not steps.contato_cadastrado
    assert_not steps.tela_cadastro_servico_acessada
    assert_not steps.servico_cadastrado
    assert_not steps.tela_cadastro_horario_acessada
    assert_not steps.horario_cadastrado
  end

end
