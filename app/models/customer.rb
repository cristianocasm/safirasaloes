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

  def safiras
    self.rewards.sum(:total_safiras)
  end
end
