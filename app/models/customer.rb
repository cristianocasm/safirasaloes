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
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :async, :omniauthable,
         :omniauth_providers => [:facebook]
  has_many :rewards
  has_many :schedules
  has_many :professionals, through: :schedules
  has_many :photo_logs

  after_commit :find_last_schedule, unless: Proc.new { |ct| ct.schedule_recovered }

  scope :filter_by_email, -> (query) { select(:id, :nome, :email, :telefone).where("email LIKE '%#{query}%'") }
  scope :filter_by_telefone, -> (query) { select(:id, :nome, :email, :telefone).where("telefone LIKE '%#{query}%'") }


  def schedules_not_more_than_12_hours_ago
    @sc ||= self.schedules.not_more_than_12_hours_ago
  end
  
  def can_send_photo?
    self.schedules_not_more_than_12_hours_ago.any?
  end

  def save_provider_uid(auth)
    authData = {
                  provider: auth.provider,
                  uid: auth.uid,
                  oauth_token: auth.credentials.token,
                  oauth_expires_at: Time.at(auth.credentials.expires_at)
                } 
    update_attributes(authData)
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end

  def gave_fb_permissions?
    self.uid.present? &&
      self.oauth_expires_at.present? &&
      self.oauth_expires_at > Time.zone.now
  end

  def find_last_schedule
    GetLastScheduleWorker.perform_async(self.email, self.id)
  end

  def safiras_somadas
    self.rewards.
            joins('left outer join professionals on rewards.professional_id = professionals.id').
            joins('left outer join statuses on professionals.status_id = statuses.id').
            where("statuses.nome in ('testando', 'assinante')").
            sum(:total_safiras)
  end

  def safiras_per(pr_id)
    self.rewards.find_by_professional_id(pr_id).try(:total_safiras) || 0
  end

  def future_schedules
    self.schedules.includes(:service).in_the_future
  end

  def my_professionals
    self.professionals.includes(:services).where(status_id: Status.where("nome IN ('testando', 'assinante')")).distinct
  end
end
