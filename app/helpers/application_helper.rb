module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end
 
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end

  def alertas_assinatura
    msg = generate_messages
    concat(content_tag(:div, msg, class: "alert alert-warning")) if msg
    nil
  end

  def generate_messages
    prof = current_professional
    if prof.status.nome == 'testando'
      "Seu período de testes finaliza no dia #{prof.data_expiracao_status.strftime('%d/%m/%Y')}. Clique aqui e torne-se Premium."
    elsif prof.status.nome == 'bloqueado'
      "Seu período de testes acabou. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades. Atenção! Seu cadastro será suspenso no dia #{prof.data_expiracao_status.strftime('%d/%m/%Y')} e você não terá mais acesso ao sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades"
    elsif prof.status.nome == 'suspenso'
      "Sua conta está suspensa e você não pode utilizar os recursos deste sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades."
    end
  end
end
