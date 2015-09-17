# class NotificationWorker
#   include Sidekiq::Worker
#   require 'open-uri'

#   sidekiq_options retry: true

#   def perform(sc, srvNome, dataInicio, horaInicio, regUrl)
#     smsConfirmationToCustomer = sms_confirmation(srvNome, dataInicio, horaInicio, sc.professional.nome)
#     smsRememberingToCustomer = sms_remembering(sc.customer, horaInicio, srvNome, sc.professional.nome, sc.id)
#     smsDivulgationToCustomer = sms_divulgation

#     smsConfirmationToProfessional = "SafiraSalões: SMS enviado p/#{ctTel}: " + smsConfirmationToCustomer
#     smsRememberingToProfessional = "SafiraSalões: SMS enviado p/#{ctTel}: " + smsRememberingToCustomer
#     smsDivulgationToProfessional = "SafiraSalões: SMS enviado p/#{ctTel}: " + smsDivulgationToCustomer

#     sms = "#{smsConfirmationToCustomer}/n\
#     #{smsRememberingToCustomer}/n\
#     #{smsDivulgationToCustomer}/n\
#     #{smsConfirmationToProfessional}/n\
#     #{smsRememberingToProfessional}/n\
#     #{smsDivulgationToProfessional}"

#     tel = "#{ctTel}/n\
#     #{ctTel}/n\
#     #{ctTel}/n\
#     #{prTel}/n\
#     #{prTel}/n\
#     #{prTel}/n"

#     dConfirmation = ""
#     mConfirmation = ""
#     yConfirmation = ""

#     dRemembering = ""
#     mRemembering = ""
#     yRemembering = ""

#     dDivulgation = ""
#     mDivulgation = ""
#     yDivulgation = ""

#     uri = "http://www.facilitamovel.com.br/api/messagesPhonesMultipleSend.ft?user=_SMS_USER_&password=_SMS_PASSWORD_&destinatario=_SMS_TELEFONE_&msg=_SMS_MSG_"

#     #http://www.facilitamovel.com.br/api/messagesPhonesMultipleSend.ft?user=xx&password=xx&destinatario=5199999999/n11999999999&msg=teste/nteste2&externalkey=xx/nxx1

#     uri.gsub!(/_SMS_USER_/, ENV['SMS_USER'])
#     uri.gsub!(/_SMS_PASSWORD_/, ENV['SMS_PASSWORD'])
#     uri.gsub!(/_SMS_MSG_/, sms)
#     uri.gsub!(/_SMS_TELEFONE_/, tel)
#     Net::HTTP.get_response(URI(uri))
#   end

#   def sms_confirmation(serviceNome, dataInicio, horaInicio, prNome)
#     sms = "Oi\n\nSeu horário para #{serviceNome} foi marcado para #{dataInicio} às #{horaInicio}\n\n-#{prNome}"
#     URI.encode(sms)
#   end

#   def sms_remembering(ct, horaInicio, serviceNome, prNome)
#     sms = "Não esqueça seu horário hoje às #{horaInicio} p/ #{serviceNome}\n\n"
#     sms += if regUrl
#       "Quer receber este e outros serviços grátis? Pergunte-me como\n\n-#{prNome}"
#     else
#       "*Logo após envie uma foto do novo visual, acumule pontos e troque por nossos serviços\n\n-#{prNome}"
#     end

#     URI.encode(sms)
#   end

#   def sms_divulgation(regUrl, prNome)
#     sms = "Gostou do novo visual? Envie uma foto do resultado p/ #{regUrl}, acumule pontos e troque por nossos serviços\n\n-#{prNome}"
#     URI.encode(sms)
#   end

#   # def perform(scEmail, prNome, serviceNome, dataInicio, horaInicio, safiras)
#   #   mandrill = Mandrill::API.new(ENV["MANDRILL_PASSWORD"])
#   #   templateName = "customer_notification"
#   #   async = false
#   #   message = generate_message(
#   #                               scEmail,
#   #                               prNome,
#   #                               serviceNome,
#   #                               dataInicio,
#   #                               horaInicio,
#   #                               safiras
#   #                             )

#   #   result = mandrill.messages.send_template(
#   #                                            templateName,
#   #                                            nil,
#   #                                            message,
#   #                                            async
#   #                                           )
#   # end

#   # private

#   # def generate_message(scEmail, prNome, serviceNome, dataInicio, horaInicio, safiras)
#   #   {
#   #     from_email: "notificacao@safirasaloes.com.br",
#   #     from_name: "SafiraSalões",
#   #     subject: "Seu horário com o(a) #{prNome} foi marcado",
#   #     to: [ { email: scEmail } ],
#   #     track_opens: true,
#   #     track_clicks: true,
#   #     inline_css: true,
#   #     preserve_recipients: false,
#   #     tracking_domain: 'stats.safirasaloes.com.br',
#   #     merge: true,
#   #     merge_vars: [ {
#   #                     rcpt: scEmail,
#   #                     vars: [
#   #                             { name: 'prof_name', content: prNome },
#   #                             { name: 'service_name', content: serviceNome },
#   #                             { name: 'data_inicio', content: dataInicio },
#   #                             { name: 'hora_inicio', content: horaInicio },
#   #                             { name: 'safiras', content: safiras}
#   #                           ]
#   #                     }
#   #                 ]
#   #   }
#   # end
# end