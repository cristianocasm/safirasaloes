# == Schema Information
#
# Table name: schedules
#
#  id              :integer          not null, primary key
#  professional_id :integer
#  customer_id     :integer
#  service_id      :integer
#  datahora_inicio :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  datahora_fim    :datetime
#

class Schedule < ActiveRecord::Base
  belongs_to :professional
  belongs_to :customer
  belongs_to :service

  validates :datahora_inicio, date: true, presence: true, date: { after_or_equal_to: Proc.new { DateTime.now } }, on: [:create, :update]
  validates :datahora_fim, date: true, date: { after_or_equal_to: Proc.new { DateTime.now } }, on: [:create, :update]
end