module CustomersHelper
  def safiras
    @safiras ||= current_customer.safiras
  end

  def economia
    @economizados ||= format("%.2f", current_customer.schedules.safiras_resgatadas * 0.50)
  end

  def nome_cliente
    current_customer.nome
  end

  def scheduled?(srv)
    @sc ||= @schedules.map(&:service).map(&:id)
    @scheduled = srv.id.in?(@sc)
  end
end
