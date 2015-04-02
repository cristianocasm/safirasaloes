# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  nome       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  has_many :rewards
  has_many :photo_logs
  has_many :schedules
  has_many :professionals, through: :schedules

  scope :filter_by_email, -> (query) { select(:id, :nome, :email, :telefone).where("email LIKE '%#{query}%'") }
  scope :filter_by_telefone, -> (query) { select(:id, :nome, :email, :telefone).where("telefone LIKE '%#{query}%'") }

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
