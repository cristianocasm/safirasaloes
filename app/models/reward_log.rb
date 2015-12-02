# == Schema Information
#
# Table name: reward_logs
#
#  id              :integer          not null, primary key
#  professional_id :integer
#  customer_id     :integer
#  safiras         :integer          default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  photo_id        :integer
#

class RewardLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :professional
  belongs_to :photo

  after_create :update_rewards_summation

  def update_rewards_summation
    rwd = Reward.find_or_initialize_by(professional: self.professional, customer: self.customer)
    rwd.total_safiras += self.safiras
    rwd.save
  end
end
