module SchedulesHelper
  def exchangeOrdersCount
    @aguardandoTroca ||= current_professional.schedules.exchangeOrderWaitingCount
  end
end
