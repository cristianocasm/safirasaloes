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
#  plan_id                :integer
#  status_id              :integer
#  data_expiracao_status  :datetime
#  contato_definido       :boolean
#  hashtag                :string(255)
#  site                   :string(255)
#  pagina_facebook        :string(255)
#

class Professional < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable

  belongs_to :plan
  belongs_to :status
  has_many :schedules
  has_many :services

  def schedules_to_calendar(start, hend)
    scs = self.schedules.where(updated_at: start..hend)
    transform(scs)
  end

  private

  def transform(scs)
    scs.map do |sc|
      {
        id:    sc.id,
        title: sc.customer.nome,
        start: sc.datahora_inicio,
        #service: sc.service.nome,
        end:   sc.datahora_fim
      }
    end
  end

end
