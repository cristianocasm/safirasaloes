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
#  site                   :string(255)
#  pagina_facebook        :string(255)
#  whatsapp               :string(255)
#  transacao_pagseguro    :string(255)
#

require 'test_helper'

class ProfessionalTest < ActiveSupport::TestCase
  should validate_presence_of(:email)
  should belong_to(:status)
  should have_many(:schedules)
  should have_many(:rewards)
  should have_many(:services)
  should have_one(:taken_step)
  should_not have_many(:photo_logs)

  test "na criação cria um registro em 'taken_steps' e associa ao profissional" do
    pr = Professional.create(email: 'email_test@test.com', password: '123456')
    assert_not_nil pr.taken_step
  end

  test "gera relatório corretamente de passos realizados" do
    rpt = Professional.taken_steps_report(3.days.ago.to_date, Date.today.to_date)
    day1 = 1.days.ago.strftime('%d/%m')
    day2 = 2.days.ago.strftime('%d/%m')
    day3 = 3.days.ago.strftime('%d/%m')
    expected = [
                [ [0, day3], [1, day2], [2, day1] ],
                [
                  {:label=>"Nº Cadastros", :data=>[ [0, 100], [1, 100], [2, 100] ], :color=>"#ff6c24"},
                  {:label=>"Nº Confirmados", :data=>[[0, 100], [1, 86], [2, 90]  ], :color=>"#ee5b13"},
                  {:label=>"Nº TC Contato", :data=>[[0, 100], [1, 86], [2, 80]   ], :color=>"#dd4a13"},
                  {:label=>"Nº Contato Cad", :data=>[[0, 100], [1, 71], [2, 80]  ], :color=>"#cc4a13"},
                  {:label=>"Nº TC Servico", :data=>[[0, 100], [1, 71], [2, 80]   ], :color=>"#bb4a13"},
                  {:label=>"Nº Serviço Cad", :data=>[[0, 75], [1, 57], [2, 60]   ], :color=>"#aa4a13"},
                  {:label=>"Nº TC Horário", :data=>[[0, 63], [1, 43], [2, 60]    ], :color=>"#994a13"},
                  {:label=>"Nº Horário Cad", :data=>[[0, 50], [1, 29], [2, 50]   ], :color=>"#884a13"}
                ]
              ]
    
    assert_equal expected, rpt
  end
end
