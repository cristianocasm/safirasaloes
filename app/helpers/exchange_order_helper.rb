module ExchangeOrderHelper
  def exchangeOrdersCount
    current_professional.exchange_orders.waitingCount
  end
end