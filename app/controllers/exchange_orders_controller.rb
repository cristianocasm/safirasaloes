class ExchangeOrdersController < ApplicationController
  def create
    eo = current_customer.exchange_orders.new(exchange_order_params)
    respond_to do |format|
      format.js { render 'create_order_exchange' }
    end
  end

  private

  def exchange_order_params
    params.require(:exchange_order).permit(:schedule_id)
  end
end
