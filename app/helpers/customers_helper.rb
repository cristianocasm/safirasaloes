module CustomersHelper
  def customer_widget_title
    case controller_name
    when 'schedules'
      widget_title('scissors', 'Meus Serviços')
    when 'photo_logs'
      widget_title('camera', 'Enviar Fotos')
    when 'photo_log_steps'
      case params[:id]
      when 'comments'
       widget_title('camera', 'Enviar Fotos (Passo 2 de 3)')
      when 'professional_info'
        widget_title('camera', 'Enviar Fotos (Passo 3 de 3)')
      when 'revision'
        widget_title('camera', 'Enviar Fotos (Revisão...)')
      end
    end
  end

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
    current_customer.try(:nome)
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
  
  private

  def widget_title(icon, text)
    concat content_tag :i, nil, class: "fa fa-#{icon}"
    concat " " + text
  end

end
