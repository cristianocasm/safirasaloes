# == Schema Information
#
# Table name: customers
#
#  id                     :integer          not null, primary key
#  nome                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  telefone               :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  schedule_recovered     :boolean          default(FALSE)
#  provider               :string(255)      default("facebook")
#  uid                    :string(255)
#  oauth_token            :string(255)
#  oauth_expires_at       :datetime
#

require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  should have_many(:schedules)
  should have_many(:rewards)
  should have_many(:photo_logs)
  should have_many(:professionals).through(:schedules)
  should_not have_many(:exchange_orders)
  should have_db_column(:telefone)

  describe "Cliente" do
    before do
      @ct = customers(:cristiano)
    end

    test "método 'my_professionals' retorna apenas profissionais em período de teste ou assinante" do
      myProfessionals = @ct.my_professionals

      @ct.professionals.distinct.each do |pr|
        if pr.status.nome.in?(%w[testando assinante])
          assert_includes( myProfessionals, pr, "Não incluindo profissional com status testando/assinante" )
        else
          assert_not_includes( myProfessionals, pr, "Incluindo profissional com status bloqueado/suspenso" )
        end
      end
    end

    test "método 'safiras_somadas' soma safiras de profissionais testando ou assinando" do
      safiras = @ct.safiras_somadas
      expected = @ct.rewards.
                      joins('left outer join professionals on rewards.professional_id = professionals.id').
                      joins('left outer join statuses on professionals.status_id = statuses.id').
                      where("statuses.nome in ('testando', 'assinante')").
                      sum(:total_safiras)
      assert_equal expected, safiras, "Possivelmente somando Safiras para profissionais bloqueados/suspenso"
    end

    test "cliente sem permissão" do
      assert_not @ct.gave_fb_permissions?
    end

    test "cliente com permissão" do
      @ct = customers(:cristiano_com_integracao)
      assert @ct.gave_fb_permissions?
    end
  end
end
