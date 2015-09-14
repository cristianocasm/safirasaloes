class NotificationWorker
  include Sidekiq::Worker
  require 'open-uri'

  sidekiq_options retry: true

  def perform(scTelefone, prNome, serviceNome, dataInicio, horaInicio, safiras)
    sms = "Oi\n\nSeu horário para #{serviceNome} foi marcado para #{dataInicio} às #{horaInicio}\n\n-#{prNome}"
    sms = URI.encode(sms)
    uri = "http://www.facilitamovel.com.br/api/simpleSend.ft?user=_SMS_USER_&password=_SMS_PASSWORD_&destinatario=_SMS_TELEFONE_&msg=_SMS_MSG_"
    uri.gsub!(/_SMS_USER_/, ENV['SMS_USER'])
    uri.gsub!(/_SMS_PASSWORD_/, ENV['SMS_PASSWORD'])
    uri.gsub!(/_SMS_TELEFONE_/, scTelefone)
    uri.gsub!(/_SMS_MSG_/, sms)
    Net::HTTP.get_response(URI(uri))
  end

  # def perform(scEmail, prNome, serviceNome, dataInicio, horaInicio, safiras)
  #   mandrill = Mandrill::API.new(ENV["MANDRILL_PASSWORD"])
  #   templateName = "customer_notification"
  #   async = false
  #   message = generate_message(
  #                               scEmail,
  #                               prNome,
  #                               serviceNome,
  #                               dataInicio,
  #                               horaInicio,
  #                               safiras
  #                             )

  #   result = mandrill.messages.send_template(
  #                                            templateName,
  #                                            nil,
  #                                            message,
  #                                            async
  #                                           )
  # end

  # private

  # def generate_message(scEmail, prNome, serviceNome, dataInicio, horaInicio, safiras)
  #   {
  #     from_email: "notificacao@safirasaloes.com.br",
  #     from_name: "SafiraSalões",
  #     subject: "Seu horário com o(a) #{prNome} foi marcado",
  #     to: [ { email: scEmail } ],
  #     track_opens: true,
  #     track_clicks: true,
  #     inline_css: true,
  #     preserve_recipients: false,
  #     tracking_domain: 'stats.safirasaloes.com.br',
  #     merge: true,
  #     merge_vars: [ {
  #                     rcpt: scEmail,
  #                     vars: [
  #                             { name: 'prof_name', content: prNome },
  #                             { name: 'service_name', content: serviceNome },
  #                             { name: 'data_inicio', content: dataInicio },
  #                             { name: 'hora_inicio', content: horaInicio },
  #                             { name: 'safiras', content: safiras}
  #                           ]
  #                     }
  #                 ]
  #   }
  # end
end