module SchedulesHelper
  def exchangeOrdersCount
    @aguardandoTrocaCount ||= current_professional.schedules.exchangeOrderWaitingCount
  end

  def exchangeOrders
    @aguardandoTroca ||= current_professional.schedules.includes(:customer, :service).exchangeOrderWaiting

    if @aguardandoTroca.present?
      @aguardandoTroca.collect do |sc|
        concat(
          content_tag(:li, id: sc.id) do
            concat(content_tag(:h6) do
              concat "Cliente: #{sc.customer.nome}"
              concat tag(:br)
              concat "Serviço: #{sc.service.nome}"
              concat tag(:br)
              concat "Data: #{sc.datahora_inicio.strftime('%d/%m/%Y')}"
              concat tag(:br)
              concat "Hora: #{sc.datahora_inicio.strftime('%H:%M')}"
              concat tag(:br)
              concat(content_tag(:span, class: "label label-danger pull-right") do
                concat link_to("Recusar",
                              accept_exchange_order_schedules_path(
                                  exchange_order: { schedule_id: sc.id, status: :reject }
                              ),
                              data: { confirm: "Tem certeza?" },
                              method: :post,
                              remote: true)
              end)
              concat(content_tag(:span, class: "label label-success pull-right") do
                concat link_to(
                              "Aceitar",
                              accept_exchange_order_schedules_path(
                                  exchange_order: { schedule_id: sc.id, status: :accept }
                              ),
                              data: { confirm: "Tem certeza?" },
                              method: :post,
                              remote: true)
              end)
            end)
            concat content_tag(:div, nil, class: 'clearfix') 
            concat tag(:hr)
          end
        )
      end
    else
      concat(
        content_tag(:li) do
          concat content_tag(:h6, 'Bom Trabalho! Você não possui Ordens de Troca em aberto. Yupii!')
          concat content_tag(:div, nil, class: 'clearfix') 
          concat tag(:hr)
        end
      )
    end
  end
end
