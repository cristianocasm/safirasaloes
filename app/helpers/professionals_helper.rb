module ProfessionalsHelper
  def nome_profissional
    current_professional.nome
  end

  def professional_widget_title
    case controller_name
    when 'professional_registrations'
      widget_title('tty', 'Dados de Contato')
    when 'services'
      widget_title('scissors', 'Serviços')
    when 'schedules'
      widget_title('calendar', 'Agenda')
    end
  end

  private

  def widget_title(icon, text)
    concat content_tag :i, nil, class: "fa fa-#{icon}"
    concat " " + text
  end
end