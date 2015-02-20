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
end
