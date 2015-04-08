# == Schema Information
#
# Table name: professionals
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  nome                   :string(255)
#  telefone               :string(255)
#  cep                    :string(255)
#  rua                    :string(255)
#  numero                 :string(255)
#  bairro                 :string(255)
#  cidade                 :string(255)
#  estado                 :string(255)
#  complemento            :string(255)
#  profissao              :string(255)
#  local_trabalho         :string(255)
#  status_id              :integer
#  data_expiracao_status  :datetime
#  contato_definido       :boolean          default(FALSE)
#  hashtag                :string(255)
#  site                   :string(255)
#  pagina_facebook        :string(255)
#  whatsapp               :string(255)
#

require 'test_helper'

class ProfessionalTest < ActiveSupport::TestCase
  should validate_presence_of(:email)
  should belong_to(:status)
  should have_many(:schedules)
  should have_many(:rewards)
  should have_many(:services)
  should have_many(:photo_logs)
end
