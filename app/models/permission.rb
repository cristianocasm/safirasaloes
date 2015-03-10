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
      if resource.status_equal_to?(:testando) || resource.status_equal_to?(:assinante)
        return true if controller.in?(%w[schedules services])
        return true if controller == "devise/registrations" && action.in?(%w[create new edit update])
      end
      return true if resource.status_equal_to?(:bloqueado) && controller == "schedules" && action.in?(%w[new index])
      return true if resource.status_equal_to?(:suspenso) && controller == "schedules" && action.in?(%w[new])
    elsif resource.instance_of? Customer
    elsif resource.nil?
      return true if controller == "devise/registrations" && action.in?(%w[create new edit update])
    end
    false
  end
end