# == Schema Information
#
# Table name: taken_steps
#
#  id                             :integer          not null, primary key
#  professional_id                :integer
#  tela_cadastro_contato_acessada :boolean          default(FALSE)
#  contato_cadastrado             :boolean          default(FALSE)
#  tela_cadastro_servico_acessada :boolean          default(FALSE)
#  servico_cadastrado             :boolean          default(FALSE)
#  tela_cadastro_horario_acessada :boolean          default(FALSE)
#  horario_cadastrado             :boolean          default(FALSE)
#  created_at                     :datetime
#  updated_at                     :datetime
#

class TakenStep < ActiveRecord::Base
  belongs_to :professional
end
