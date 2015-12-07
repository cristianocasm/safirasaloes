# == Schema Information
#
# Table name: customer_invitations
#
#  id                   :integer          not null, primary key
#  access_token         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  recovered            :boolean          default(FALSE)
#  recompensa           :integer
#  customer_telefone    :string(255)
#  customer_id          :integer
#  invitation_status_id :integer
#  validation_token     :string(255)
#

class CustomerInvitation < ActiveRecord::Base
  CUSTOMERS_SMS = "Olá\n\nAqui estão suas fotos: _REG_URL_\n\nAcesse, compartilhe e ganhe pontos para trocar por meus serviços :D\n\n_PROF_NAME_"
  PROFESSIONALS_SMS = "_CUSTOMER_INFO_ acaba de divulgar seu trabalho para os amigos.\n\nPREPARE-SE! Novos clientes vem por aí :D\n\nPARABÉNS pelo ótimo trabalho!\n\nsafirasaloes"

  
  has_secure_token :access_token, :validation_token

  attr_accessor :get_safiras

  before_create :limit_token, :recover_safiras_from_customer, :set_invitation_status
  after_create  :invite_customer

  has_many :scheduled_msgs
  has_many :photos
  belongs_to :customer
  belongs_to :invitation_status
  belongs_to :professional

  # scope :find_by_token, -> (t) { where("token = ? AND recovered = false", t) }

  # Quando customer_id == nil, cliente não está cadastrado no safiras
  # Assim é necessário 
  def award_rewards(customer_id = nil, photo_id)
    if customer_id.present?
      unless self.recovered?
        self.update_attribute(:customer_id, customer_id)

        ctm = self.customer
        prof = self.photos.first.professional

        RewardLog.create(professional: prof, customer: ctm, safiras: self.recompensa, photo_id: photo_id)
        self.update_attribute(:recovered, true)
      end
    end

    ctmInfo = self.customer.try(:nome) || self.customer_telefone
    sms = PROFESSIONALS_SMS.gsub('_CUSTOMER_INFO_', ctmInfo)
    sms = URI.encode(sms)
    tel = self.photos.first.professional.get_cellphone.gsub(/\D/, '')
    fire( sms, tel )
  end

  def limit_token
    self.access_token = self.access_token[0..4]
  end

  def visto!
    vId = InvitationStatus.find_by_nome('visto').id

    self.update_attribute(:invitation_status_id, vId)
  end

  # Um convite é definido como "visto" se tiver sido visto ou aceito
  def visto?
    vId = InvitationStatus.find_by_nome('visto').id
    aId = InvitationStatus.find_by_nome('aceito')

    self.invitation_status.id.in?([vId, aId])
  end

  def recover_safiras_from_customer
    if self.customer.present? && self.get_safiras == 'yes'
      ctm = self.customer
      prof = self.photos.first.professional
      tSafiras = Reward.find_or_initialize_by(professional: prof, customer: ctm).total_safiras
      
      # Instrução abaixo criar uma recompensa negativa de valor igual ao total de safiras
      # acumuladas pelo cliente com o profissional. Como RewardLog tem uma função para
      # atualizar a somatória de Reward sempre que uma nova recompensa é criada, o resultado
      # é a extração total das safiras do cliente junto ao profissional.
      RewardLog.create(professional: prof, customer: customer, safiras: -tSafiras)
    end
  end

  def invite_customer
    regUrl = generate_registration_url
    prNome = self.photos.first.professional.nome
    sms = CUSTOMERS_SMS.gsub('_REG_URL_', regUrl).gsub('_PROF_NAME_', prNome)
    sms = URI.encode(sms)
    tel = self.customer_telefone.gsub(/\D/, '')
    
    fire( sms, tel )
  end

  private

  def set_invitation_status
    self.invitation_status = InvitationStatus.find_by_nome('nVisto')
  end

  def generate_registration_url
    "http://safirasaloes.com.br/fotos/#{self.access_token}"
  end

  def fire(msg, tel, schedule = false, date = {})
    uri = "http://www.facilitamovel.com.br/api/simpleSend.ft?user=_SMS_USER_&password=_SMS_PASSWORD_&destinatario=_SMS_TELEFONE_&msg=_SMS_MSG_"
    uri.gsub!(/_SMS_USER_/, ENV['SMS_USER'])
    uri.gsub!(/_SMS_PASSWORD_/, ENV['SMS_PASSWORD'])
    uri.gsub!(/_SMS_MSG_/, msg)
    uri.gsub!(/_SMS_TELEFONE_/, tel)
    if schedule
      uri += "&day=_SMS_DAY_&month=_SMS_MONTH_&year=_SMS_YEAR_&formHour=_SMS_HOUR_&formMinute=_SMS_MINUTE_"
      uri.gsub!(/_SMS_DAY_/, date[:d])
      uri.gsub!(/_SMS_MONTH_/, date[:M])
      uri.gsub!(/_SMS_YEAR_/, date[:y])
      uri.gsub!(/_SMS_HOUR_/, date[:h])
      uri.gsub!(/_SMS_MINUTE_/, date[:m])
    end

    if Rails.env.production?
      Net::HTTP.get_response(URI(uri))
    else
      "6;123456".tap { |o| o.define_singleton_method(:body) { self } }
    end
  end
end
