class ExchangeOrder < ActiveRecord::Base
  belongs_to(:schedule)
  belongs_to(:customer)
  belongs_to(:professional)
  belongs_to(:order_status)

  scope :waitingCount, -> { where("order_status_id = ?", OrderStatus.find_by_nome('aguardando')).size }
end
