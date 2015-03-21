class OrderStatus < ActiveRecord::Base
  has_many :exchange_orders
end
