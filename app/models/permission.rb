class Permission < Struct.new(:resource)
  def allow?(controller, action)
    return true if controller == "notifications" && action.in?(%w[new retorno_pagamento])
    return true if controller == "static_pages" && action.in?(%w[privacy])
    return true if controller == "customers" && action.in?(%w[new create])
    return true if controller == "devise/professional_registrations" && action.in?(%w[new create])
    return true if controller == "sessions" && action.in?(%w[new create destroy])
    return true if controller == "devise/confirmations" && action.in?(%w[new create show])
    return true if controller == "devise/passwords" && action.in?(%w[new create edit update])
    if resource.instance_of? Professional
      return professional_permission(controller, action)
    elsif resource.instance_of? Customer
      return customer_permission(controller, action)
    elsif resource.nil?
      return false
    end
  end

  def forçar_cadastro_dos_dados_de_contato?(controller, action)
    return false if resource.nil?
    if resource.instance_of?(Professional)
      return false if resource.status_equal_to?(:bloqueado) || resource.status_equal_to?(:suspenso)
      return true if( !resource.has_contato_definido? && ( controller != "devise/professional_registrations" || !action.in?(%w[edit update]) ) && !tentando_cadastrar_servico?(controller, action) ) 
    end
    false
  end

  def forcar_cadastro_de_servico?(controller, action)
    return false if resource.nil?
    if resource.instance_of?(Professional)
      return false if resource.status_equal_to?(:bloqueado) || resource.status_equal_to?(:suspenso)
      return true if( !resource.has_servico_definido? && ( controller != "services" || !action.in?(%w[new create]) ) && !tentando_cadastrar_contato?(controller, action) ) 
    end
    false
  end

  private

  def tentando_cadastrar_contato?(controller, action)
    !resource.has_contato_definido? && controller == "devise/professional_registrations" && action.in?(%w[edit update])
  end

  def tentando_cadastrar_servico?(controller, action)
    !resource.has_servico_definido? && controller == "services" && action.in?(%w[new create])
  end

  def professional_permission(controller, action)
    if resource.testando? || resource.assinante?
      return true if controller == "services" && action.in?(%w[new index update create edit show destroy])
      return true if controller == "schedules" && action.in?(%w[new index update create edit show destroy get_last_two_months_scheduled_customers])
      return true if controller == "customers" && action.in?(%w[filter_by_email filter_by_telefone])
      return true if controller == "devise/professional_registrations" && action.in?(%w[edit update])
      return true if controller == "rewards" && action.in?(%w[get_customer_rewards])
    end

    return true if resource.bloqueado? && controller == "schedules" && action.in?(%w[new index])
    return true if resource.suspenso? && controller == "schedules" && action.in?(%w[new])
    return false
  end

  def customer_permission(controller, action)
    return true if controller.in?(%w[photo_logs]) && action.in?(%w[create new index destroy send_to_fb])
    return true if controller.in?(%w[schedules]) && action.in?(%w[meus_servicos_por_profissionais])
    return true if controller.in?(%w[customer_omniauth_callbacks]) && action.in?(%w[facebook])
    return false
  end

end