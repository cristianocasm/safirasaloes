# == Schema Information
#
# Table name: customer_invitations
#
#  id                :integer          not null, primary key
#  token             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  recovered         :boolean          default(FALSE)
#  recompensa        :integer
#  customer_telefone :string(255)
#

class CustomerInvitation < ActiveRecord::Base
  SMS_MSG = "Olá\n\nAqui estão suas fotos: _REG_URL_\n\nAcesse, compartilhe e ganhe pontos para trocar por meus serviços :D\n\n_PROF_NAME_"
  
  has_secure_token :token

  before_create :limit_token
  after_create  :invite_customer

  has_many :scheduled_msgs
  has_many :photos

  scope :find_by_photo_and_token, -> (p, t) { where("photo_id = ? AND token = ? AND recovered = false", p, t) }

  def limit_token
    self.token = self.token[0..4]
  end

  def invite_customer
    send_sms(
      prNome: self.photos.first.professional.nome,
      ctTel: self.customer_telefone.gsub(/\D/, ''),
      regUrl: generate_registration_url
    )
  end

  private

  def generate_registration_url
    "http://safirasaloes.com.br/fotos?s=#{self.token}"
  end

  def send_sms(options)
    sms = SMS_MSG.gsub('_REG_URL_', options[:regUrl]).gsub('_PROF_NAME_', options[:prNome])
    tel = options[:ctTel]
    fire(sms, tel)
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
