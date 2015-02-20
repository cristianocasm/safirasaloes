# == Schema Information
#
# Table name: rewards
#
#  id                 :integer          not null, primary key
#  service_id         :integer
#  quantidade_safiras :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Reward < ActiveRecord::Base
end
