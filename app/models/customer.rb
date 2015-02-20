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
  has_many :schedules
end
