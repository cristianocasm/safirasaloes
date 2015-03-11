class Permission < Struct.new(:resource)
  # def allow?(controller, action)
  #   return true if controller == "sessions"
  #   return true if controller == "users" && action.in?(%w[new create])
  #   return true if controller == "topics" && action.in?(%w[index show])
  #   if resource
  #     return true if controller == "users" && action.in?(%w[edit update])
  #     return true if controller == "topics" && action != "destroy"
  #     return true if resource.admin?
  #   endre
  #   false
  # end

  def allow?(controller, action)
    return true if controller == "devise/sessions"
    return true if controller == "devise/confirmations"
    return true if controller == "devise/passwords"
    if resource.instance_of? Professional
      if resource.testando? || resource.assinante?
        return true if controller.in?(%w[schedules services])
        return true if controller == "devise/registrations" && action.in?(%w[create new edit update])
      end
      return true if resource.bloqueado? && controller == "schedules" && action.in?(%w[new index])
      return true if resource.suspenso? && controller == "schedules" && action.in?(%w[new])
    elsif resource.instance_of? Customer
    elsif resource.nil?
      return true if controller == "devise/registrations" && action.in?(%w[create new edit update])
    end
    false
  end

  # Redirecionar para configuração de informações?
  # def forçar_cadastro_dos_dados_de_contato?(controller, action)
  #   return false if resource.nil?
  #   if resource.instance_of?(Professional)
  #     return false if resource.status_equal_to?(:bloqueado) || resource.status_equal_to?(:suspenso)
  #     return true if( !resource.has_contato_definido? && ( controller != "devise/registrations" || !action.in?(%w[edit update]) ) )
  #   end
  #   false
  # end

  # def forcar_cadastro_de_servico?(controller, action)
  #   byebug
  #   return false if resource.nil?
  #   if resource.instance_of?(Professional)
  #     return false if resource.status_equal_to?(:bloqueado) || resource.status_equal_to?(:suspenso)
  #     return true if( !resource.has_servico_definido? && !( !resource.has_contato_definido? && ( controller != "devise/registrations" || !action.in?(%w[edit update]) ) ) && ( controller != "services" || !action.in?(%w[new create]) ) )
  #   end
  #   false
  # end 

  def forçar_cadastro_dos_dados_de_contato?(controller, action)
    return false if resource.nil?
    if resource.instance_of?(Professional)
      return false if resource.status_equal_to?(:bloqueado) || resource.status_equal_to?(:suspenso)
      return true if( !resource.has_contato_definido? && ( controller != "devise/registrations" || !action.in?(%w[edit update]) ) && !tentando_cadastrar_servico?(controller, action) ) 
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

  def tentando_cadastrar_contato?(controller, action)
    !resource.has_contato_definido? && controller == "devise/registrations" && action.in?(%w[edit update])
  end

  def tentando_cadastrar_servico?(controller, action)
    !resource.has_servico_definido? && controller == "services" && action.in?(%w[new create])
  end
end