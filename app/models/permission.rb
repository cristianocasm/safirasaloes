class Permission < Struct.new(:resource)
  def allow?(controller, action)
    return true if controller == "notifications" && action.in?(%w[new retorno_pagamento])
    return true if controller == "static_pages"# && action.in?(%w[privacy])
    # return true if controller == "customers" && action.in?(%w[new create])
    return true if controller == "devise/professional_registrations" && action.in?(%w[new create])
    return true if controller == "sessions" && action.in?(%w[new create destroy])
    return true if controller == "omniauth_callbacks" && action.in?(%w[facebook])
    # return true if controller == "devise/professional_confirmations" && action.in?(%w[new create show])
    return true if controller == "devise/passwords" && action.in?(%w[new create edit update])
    # return true if controller == "photo_logs" && action.in?(%w[new create index])
    # return true if controller == "photo_log_steps" && action.in?(%w[index show update])
    return true if controller == "photos" && action.in?(%w[index my_site])
    return true if controller == "rewards" && action.in?(%w[assign_rewards_to_customer])
    
    if resource.instance_of? Professional
      return professional_permission(controller, action)
    elsif resource.instance_of? Customer
      return customer_permission(controller, action)
    elsif resource.nil?
      return true if controller == "devise/sessions" && action == "new"
      return false
    end
  end

  def forçar_cadastro_dos_dados_de_contato?(controller, action)
    return false if resource.nil?
    if resource.instance_of?(Professional)
      return false if resource.status_equal_to?(:bloqueado) || resource.status_equal_to?(:suspenso)
      return true if(contato_nao_definido?(controller, action) ) 
    end
    false
  end

  private

  def contato_nao_definido?(controller, action)
    !resource.has_contato_definido? && !controller.in?(%w[sign_up_steps devise/professional_registrations])
  end

  def professional_permission(controller, action)
    if resource.testando? || resource.assinante?
      return true if controller == "photos" && action.in?(%w[new create destroy])
      return true if controller == "rewards" && action.in?(%w[get_rewards_by_customers_telephone])
      return true if controller == "sign_up_steps" && action.in?(%w[index show update])
      return true if controller == "devise/professional_registrations" && action.in?(%w[update])
      # return true if controller == "services" && action.in?(%w[new index update create edit show destroy])
      # return true if controller == "schedules" && action.in?(%w[new index update create edit show destroy get_last_two_months_scheduled_customers show_invitation_template])
      # return true if controller == "photos" && action.in?(%w[new])
      # return true if controller == "customers" && action.in?(%w[filter_by_email filter_by_telefone])
    end

    # return true if resource.bloqueado? && controller == "schedules" && action.in?(%w[new index])
    # return true if resource.suspenso? && controller == "schedules" && action.in?(%w[new])
    return false
  end

  def customer_permission(controller, action)
    return true if controller.in?(%w[customers]) && action.in?(%w[minhas_safiras_por_profissionais])
    # return true if controller.in?(%w[photo_logs]) && action.in?(%w[create new index destroy send_to_fb])
    # return true if controller.in?(%w[schedules]) && action.in?(%w[meus_servicos_por_profissionais])
    # return true if controller.in?(%w[photo_log_steps]) && action.in?(%w[index show update])
    return false
  end

end