class PhotoLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :professional
  belongs_to :schedule
  belongs_to :service
end
