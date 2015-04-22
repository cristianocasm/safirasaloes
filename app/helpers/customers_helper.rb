module CustomersHelper
  def safiras
    @safiras ||= current_customer.safiras_somadas
  end

  def safiras_percentage_by(service_price)
    percentage = ( prof_safiras / ( service_price * 2 ) ) * 100
    percentage > 100 ? 100 : percentage
  end

  def economia
    @economizados ||= format("%.2f", current_customer.schedules.safiras_resgatadas * 0.50)
  end

  def nome_cliente
    current_customer.nome
  end

  def prof_safiras(pr_id=nil)
    @safirasDoProf = (pr_id.present? ? current_customer.safiras_per(pr_id) : @safirasDoProf)
  end

  def enough_safiras?(service_preco)
    prof_safiras >= service_preco * 2
  end

  def insert_badge
    concat(
      content_tag(
        :div,
        {
          'class' => "col-xs-12 col-md-4 button-middle dica",
          'data-toggle' => "popover",
          'data-trigger' => "hover",
          'data-placement'=>"top",
          'data-html' => "true",
          'title' => "Parabéns!",
          'data-content' => "Você acumulou Safiras suficiente para trocar por este serviço.<br /><br />Para efetuar a troca, marque um horário com o profissional e diga a ele que utilize suas Safiras como pagamento."
        }
      ) do
        concat image_tag "badge.png"
      end
    )
  end
  
  # def insert_button(srv_preco, sc)
  #   if can_send_request?(srv_preco, total_safiras)

  #     if request_inexistent(sc)
  #       insert_enabled_button_for_inexistent_request(sc.id)
  #     elsif request_waiting(sc)
  #       insert_disabled_button_for_request_waiting
  #     elsif request_accepted(sc)
  #       insert_disabled_button_for_request_accepted
  #     elsif request_rejected(sc)
  #       insert_enabled_button_for_request_rejected(sc.id, sc.motivo_recusa)
  #     end
    
  #   else

  #     if scheduled?
  #       insert_disabled_button_for(:without_enough_safiras, srv_preco, total_safiras)
  #     elsif enough_safiras?(total_safiras, srv_preco)
  #       insert_disabled_button_for(:non_scheduled, srv_preco, total_safiras)
  #     else
  #       insert_disabled_button_for(:poor_customer, srv_preco, total_safiras)
  #     end

  #   end

  # end




  private

  # def get_schedules(service_id)
  #   @future_schedules.find_by_service_id(service_id)
  # end

  # def get_exchange_order_inexistente_id
  #   @eoInexistenteId ||= ExchangeOrderStatus.find_by_nome('inexistente').id
  # end

  # def get_exchange_order_aguardando_id
  #   @eoAguardandoId ||= ExchangeOrderStatus.find_by_nome('aguardando').id
  # end

  # def get_exchange_order_accepted_id
  #   @eoAceitoId ||= ExchangeOrderStatus.find_by_nome('aceita').id
  # end

  # def get_exchange_order_rejected_id
  #   @eoRejeitadoId ||= ExchangeOrderStatus.find_by_nome('recusada').id
  # end

  # def request_inexistent(sc)
  #   sc.exchange_order_status.id == get_exchange_order_inexistente_id
  # end

  # def request_waiting(sc)
  #   sc.exchange_order_status.id == get_exchange_order_aguardando_id
  # end

  # def request_accepted(sc)
  #   sc.exchange_order_status.id == get_exchange_order_accepted_id
  # end

  # def request_rejected(sc)
  #   sc.exchange_order_status.id == get_exchange_order_rejected_id
  # end

  # def insert_enabled_button_for_inexistent_request(sc_id)
  #   concat(
  #     content_tag(:div, class: "col-xs-12 col-md-4 button-middle") do
  #       concat link_to 'Enviar Solicitação Agora', create_exchange_order_path(exchange_order: { schedule_id: sc_id }), :data => { :confirm => "Enviar Solicitação?" }, :method=>:post, remote: true, class: "btn btn-warning"
  #     end
  #   )
  # end


  # def insert_disabled_button_for_request_accepted
  #   concat(
  #     content_tag(
  #       :div,
  #       {
  #         'class' => "col-xs-12 col-md-4 button-middle dica",
  #         'data-toggle' => "popover",
  #         'data-trigger' => "hover",
  #         'data-placement'=>"left",
  #         'data-html' => "true",
  #         'title' => "Yuuuupppppppiiiiiiii!!!!!!!",
  #         'data-content' => "Parabéns! O profissional aceitou sua solicitação. <br /><br /> Compareça ao estabelecimento no horário marcado e <b>receba o serviço gratuitamente</b>."
  #       }
  #     ) do
  #       concat link_to 'Solicitação Aceita', {}, disabled: true, class: "btn btn-success"
  #     end
  #   )
  # end

  # def insert_enabled_button_for_request_rejected(sc_id, sc_motivo_recusa)
  #   concat(
  #     content_tag(
  #       :div,
  #       {
  #         'class' => "col-xs-12 col-md-4 button-middle dica",
  #         'data-toggle' => "popover",
  #         'data-trigger' => "hover",
  #         'data-placement'=>"left",
  #         'data-html' => "true",
  #         'title' => "Solicitação Rejeitada pelo Profissional",
  #         'data-content' => "O profissional rejeitou sua solicitação com a seguinte justificativa: \"<i>#{sc_motivo_recusa}</i>\".<br /><br /> Caso não concorde você poderá contactá-lo e resubmeter a solicitação."
  #       }
  #     ) do 
  #       concat link_to 'Solicitação Rejeitada', create_exchange_order_path(exchange_order: { schedule_id: sc_id }), :data => { :confirm => "Reenviar Solicitação?" }, :method=>:post, remote: true, class: "btn btn-danger"
  #     end
  #   )
  # end

  # def insert_disabled_button_for(opt, srv_preco, total_safiras)
  #   concat(
  #     content_tag(
  #       :div,
  #       {
  #         'class' => "col-xs-12 col-md-4 button-middle dica",
  #         'data-toggle' => "popover",
  #         'data-trigger' => "hover",
  #         'data-placement'=>"left",
  #         'data-html' => "true",
  #         'title' => "Que pena...",
  #         'data-content' => get_popover_message(opt, srv_preco, total_safiras)
  #       }
  #     ) do
  #       concat link_to button_message(opt, srv_preco), {}, disabled: true, class: "btn btn-warning"
  #     end
  #   )
  # end

  # def insert_data_and_time(data_hora)
  #   concat(
  #     content_tag(:h5, "Data: #{data_hora.strftime('%d/%m/%Y')}") +
  #     content_tag(:h5, "Hora: #{data_hora.strftime('%H:%M')}")
  #   )
  # end

  # def can_send_request?(service_preco, total_safiras)
  #   scheduled? && enough_safiras?(total_safiras, service_preco)
  # end



  # def scheduled?(service_id=nil)
  #   @sc = (service_id.present? ? service_id.in?(future_schedules) : @sc)
  # end

  # def future_schedules
  #   @futureSc ||= @future_schedules.map(&:service).map(&:id)
  # end

  # def get_popover_message(opt, srv_preco, total_safiras)
  #   safiraStep = ""
  #   scheduleStep = ""

  #   msg = "Você ainda não pode enviar uma solicitação de troca para este serviço.<br/>
  #     Para trocar suas Safiras por este serviço
  #     <ol>
  #       SAFIRA_STEP_HERE
  #       SCHEDULE_STEP_HERE
  #       <li> Acesse esta página novamente, clique neste botão (ele estará ativo) para criar sua solicitação de troca </li>
  #       <li> <b>Receba o serviço gratuitamente</b> </li>
  #     </ol>"

  #   case opt
  #   when :poor_customer
  #     safiraStep = "<li>Junte mais <b>#{ ((srv_preco / 0.5) - (total_safiras)).ceil }</b> Safiras</li>"
  #     scheduleStep = "<li>Marque um horário com o profissional</li>"
  #   when :non_scheduled
  #     safiraStep = "<li style='color: green'><b>Junte Safiras Suficiente <span><i class='fa fa-check'></i></span></b></li>"
  #     scheduleStep = "<li>Marque um horário com o profissional</li>"
  #   when :without_enough_safiras
  #     safiraStep = "<li>Junte mais <b>#{ ((srv_preco / 0.5) - (total_safiras)).ceil }</b> Safiras</li>"
  #     scheduleStep = "<li style='color: green'>Marque um horário  <span><i class='fa fa-check'></i></span></li>"
  #   end

  #   msg.
  #     sub('SAFIRA_STEP_HERE', safiraStep).
  #     sub('SCHEDULE_STEP_HERE', scheduleStep)
  # end

  # def button_message(opt, srv_preco)
  #   case opt
  #   when :poor_customer
  #     "Requer mais #{pluralize(((srv_preco / 0.5) - (total_safiras)).ceil, 'Safira')}"
  #   when :non_scheduled
  #     "Requer Horário Marcado"
  #   when :without_enough_safiras
  #     "Requer mais #{pluralize(((srv_preco / 0.5) - (total_safiras)).ceil, 'Safira')}"      
  #   end
  # end

end
