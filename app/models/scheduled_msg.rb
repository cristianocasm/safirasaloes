# == Schema Information
#
# Table name: scheduled_msgs
#
#  id          :integer          not null, primary key
#  schedule_id :integer
#  api_id      :integer
#

class ScheduledMsg < ActiveRecord::Base
  belongs_to :schedule
end
