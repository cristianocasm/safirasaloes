# == Schema Information
#
# Table name: scheduled_msgs
#
#  id                     :integer          not null, primary key
#  api_id                 :integer
#  customer_invitation_id :integer
#

class ScheduledMsg < ActiveRecord::Base
  belongs_to :customer_invitation
end
