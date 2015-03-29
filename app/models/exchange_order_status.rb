class ExchangeOrderStatus < ActiveRecord::Base
  has_many(:schedules)
end
