module AdminsHelper
  def admin_widget_title
    case controller_name
    when 'dashboard'; widget_title('home', 'Dados de Contato'); end
  end
end
