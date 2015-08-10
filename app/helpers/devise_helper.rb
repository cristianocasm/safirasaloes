module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    flash[:error] = flash_errors(resource)
  end

  def prohibited_path
    # path = request.path
    # meth = request.request_method

    # ( path == new_professional_session_path && meth.in?(%w[GET]) ) ||
    # ( path == edit_professional_password_path && meth.in?(%w[GET]) ) ||
    # ( path == professional_password_path && meth.in?(%w[PATCH PUT]) ) ||
    # ( path == edit_customer_password_path && meth.in?(%w[GET PATCH PUT]) ) ||
    # ( path == customer_password_path && meth.in?(%w[PATCH PUT]) ) ||
    # ( path == new_customer_registration_path && meth.in?(%w[GET]) ) ||
    # ( path == customer_registration_path && meth.in?(%w[POST]) )

    contro = params[:controller]
    action = params[:action]

    ( contro == 'devise/passwords' && action.in?(%w[edit update]) ) ||
    ( contro == 'customers' && action.in?(%w[new create]) ) ||
    ( contro == 'sessions' && action.in?(%w[new create]) )

    # request.path.in?(
    #   [
    #     new_professional_session_path,
    #     edit_professional_password_path,
    #     edit_customer_password_path,
    #     new_customer_registration_path
    #     ])
  end

  def label_name
    if resource_name == :professional
      "profissional"
    elsif resource_name == :customer
      "cliente"
    end
  end

  def toggle_scope_path
    path = request.path
    path.sub!(label_name, toggle_resource_name('pt').to_s)
  end

  def toggle_resource_name(lang = 'en')
    if resource_name == :customer
      return :professional if lang == 'en'
      return :profissional if lang == 'pt'
    elsif resource_name == :professional
      return :customer if lang == 'en'
      return :cliente if lang == 'pt'
    end
  end
end