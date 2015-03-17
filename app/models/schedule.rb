# == Schema Information
#
# Table name: schedules
#
#  id                    :integer          not null, primary key
#  professional_id       :integer
#  customer_id           :integer
#  service_id            :integer
#  datahora_inicio       :datetime
#  created_at            :datetime
#  updated_at            :datetime
#  datahora_fim          :datetime
#  recompensa_divulgacao :integer
#

class Schedule < ActiveRecord::Base
  belongs_to :professional
  belongs_to :customer
  belongs_to :service

  validates_presence_of :professional_id
  validates_presence_of :service_id
  validates :datahora_inicio, date: true, presence: true, date: { after_or_equal_to: Proc.new { DateTime.now } }, on: [:create, :update]
  validates :datahora_fim, date: true, date: { after: Proc.new { :datahora_inicio } }, on: [:create, :update]

  scope :get_last_two_months_scheduled_customers, -> (prof_id) {
                                                                  select('DISTINCT(nome), customer_id AS id', :email, :telefone).
                                                                  where(professional_id: prof_id).
                                                                  where(datahora_inicio: 60.days.ago .. 7.days.ago)
                                                                }
end
