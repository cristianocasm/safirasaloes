class NotificationWorker
  include Sidekiq::Worker

  sidekiq_options retry: true

  def perform(scEmail, prNome, serviceNome, dataInicio, horaInicio, safiras)
    mandrill = Mandrill::API.new(ENV["MANDRILL_PASSWORD"])
    templateName = "customer_notification"
    async = false
    message = generate_message(
                                scEmail,
                                prNome,
                                serviceNome,
                                dataInicio,
                                horaInicio,
                                safiras
                              )

    result = mandrill.messages.send_template(
                                             templateName,
                                             nil,
                                             message,
                                             async
                                            )
    puts result
  end

  private

  def generate_message(scEmail, prNome, serviceNome, dataInicio, horaInicio, safiras)
    {
      from_email: "notificacao@safirasaloes.com.br",
      from_name: "SafiraSalões",
      subject: "Seu horário no #{prNome} foi marcado",
      to: [ { email: scEmail } ],
      track_opens: true,
      track_clicks: true,
      inline_css: true,
      preserve_recipients: false,
      tracking_domain: 'stats.safirasaloes.com.br',
      merge: true,
      merge_vars: [ {
                      rcpt: scEmail,
                      vars: [
                              { name: 'prof_name', content: prNome },
                              { name: 'service_name', content: serviceNome },
                              { name: 'data_inicio', content: dataInicio },
                              { name: 'hora_inicio', content: horaInicio },
                              { name: 'safiras', content: safiras}
                            ]
                      }
                  ]
    }
  end
end