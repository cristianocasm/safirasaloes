# == Schema Information
#
# Table name: photo_logs
#
#  id              :integer          not null, primary key
#  customer_id     :integer
#  professional_id :integer
#  schedule_id     :integer
#  service_id      :integer
#  safiras         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class PhotoLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :professional
  belongs_to :schedule
  belongs_to :service
end
