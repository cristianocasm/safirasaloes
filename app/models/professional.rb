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

  belongs_to :status
  has_many :schedules
  has_many :services

  before_create :create_hashtag, :define_status

  def schedules_to_calendar(start, hend)
    scs = self.schedules.where(updated_at: start..hend)
    transform(scs)
  end

  def services_ordered
    services.order(:nome)
  end
  
  def suspenso?
    true if self.status.nome == 'suspenso'
  end

  def bloqueado?
    true if self.status.nome == 'bloqueado'    
  end

  def status_equal_to?(status)
    update_status
    self.status.nome == status.to_s
  end

  private

  def transform(scs)
    scs.map do |sc|
      {
        id:    sc.id,
        title: sc.customer.try(:nome),
        start: sc.datahora_inicio,
        #service: sc.service.nome,
        end:   sc.datahora_fim
      }
    end
  end

  def update_status
    if status_expired?
      nextStatus = next_status
      self.update(status_id: nextStatus.id, data_expiracao_status: Time.zone.now + nextStatus.dias_vigencia.days)
    end
  end

  def next_status
    if self.status.nome == 'testando'
      Status.find_by_nome 'bloqueado'
    elsif self.status.nome == 'bloqueado'
      Status.find_by_nome 'suspenso'
    end
  end

  def status_expired?
    (self.status.nome == 'testando' || self.status.nome == 'bloqueado') &&
      self.data_expiracao_status < Time.zone.now
  end

  def create_hashtag
    o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
    string = ""
    begin
      string = (0..3).map { o[rand(o.length)] }.join
    end while !Professional.find_by_hashtag(string).blank?
    self.hashtag = string
  end

  def define_status
    status = Status.find_by_nome('testando')
    self.status_id = status.id
    self.data_expiracao_status = Time.zone.now + status.dias_vigencia.days
  end


end
