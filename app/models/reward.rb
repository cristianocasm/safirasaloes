# == Schema Information
#
# Table name: rewards
#
#  id              :integer          not null, primary key
#  professional_id :integer
#  customer_id     :integer
#  total_safiras   :integer          default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  photo_id        :integer
#

class Reward < ActiveRecord::Base
  belongs_to :customer
  belongs_to :professional
  belongs_to :photo
end
