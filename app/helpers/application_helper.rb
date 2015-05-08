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
    if msg.present?
      concat(content_tag(:div, class: "alert alert-warning", style: "text-align: center;") do
              concat msg.html_safe
              concat(content_tag(:form, action: 'https://pagseguro.uol.com.br/v2/pre-approvals/request.html', method: 'post') do
                      concat content_tag(:input, nil, type: 'hidden', name: 'code', value: 'BB93F2ED11118A80047FBFA7FC08A76F')
                      concat content_tag(:input, nil, type: 'image', src: 'https://p.simg.uol.com.br/out/pagseguro/i/botoes/assinaturas/205x30-assinar.gif', name: 'submit', alt: 'Pague com PagSeguro - é rápido, grátis e seguro!')
                    end)
              # concat(content_tag(:form, action: 'https://pagseguro.uol.com.br/v2/pre-approvals/request.html', method: 'post') do
              #         concat content_tag(:input, nil, type: 'hidden', name: 'code', value: '5A01330DEFEF9D6004544FA0E1DA43A6')
              #         concat content_tag(:input, nil, type: 'image', src: 'https://p.simg.uol.com.br/out/pagseguro/i/botoes/assinaturas/205x30-assinar.gif', name: 'submit', alt: 'Pague com PagSeguro - é rápido, grátis e seguro!')
              #       end)
            end) 
    end
  end

  def generate_messages
    prof = current_professional
    if prof.status.nome == 'testando'
      "Seu período de testes finaliza no dia #{prof.data_expiracao_status.strftime('%d/%m/%Y')}.<br/>Clique no botão abaixo para tornar-se <b>PREMIUM</B>:"
    elsif prof.status.nome == 'bloqueado'
      "<b>SEU PERÍODO DE TESTES ACABOU</b>!<br/>Isso significa que você só poderá visualizar os horários marcados em sua agenda - nada mais.<br/>Clique no botão abaixo para tornar-se <b>PREMIUM</b> e reabilitar todas as funcionalidades.<br/><i>Atenção! Seu cadastro será suspenso no dia #{prof.data_expiracao_status.strftime('%d/%m/%Y')} e você não terá mais acesso ao sistema.</i>"
    elsif prof.status.nome == 'suspenso'
      "Sua conta está <b>SUSPENSA</b> e você não pode mais utilizar os recursos deste sistema.<br />Clique no botão abaixo para tornar-se Premium e <b>REABILITAR TODAS AS FUNCIONALIDADES <u>INSTANTANEAMENTE</u></b>."
    end
  end
end
