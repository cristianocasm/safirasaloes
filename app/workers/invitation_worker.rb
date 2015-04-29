class InvitationWorker
  include Sidekiq::Worker

  sidekiq_options retry: true

  # Envia e-mail de convite para cliente ainda não cadastrado, mas que
  # teve horário marcado com e-mail definido por @scEmail
  # params
  # @prNome - Nome do profissional que marcou o horário
  # @dataInicio - Data do horário marcado
  # @horaInicio - Hora inicial do horário marcado
  # @scEmail - E-mail do cliente ainda não cadastrado
  # @serviceNome - Nome do serviço que será fornecido pelo profissional ao cliente
  # @registrationURL - URL no qual cliente será habilitado a fazer seu cadastro
  def perform(prNome, dataInicio, horaInicio, scEmail, serviceNome, registrationURL)
    mandrill = Mandrill::API.new(ENV["MANDRILL_PASSWORD"])
    templateName = "customer_invitation"
    async = false
    message = generate_message(
                                scEmail,
                                registrationURL, 
                                prNome,
                                serviceNome,
                                dataInicio,
                                horaInicio
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

  def generate_message(scEmail, registrationURL, prNome, serviceNome, dataInicio, horaInicio)
    {
      from_email: "convite@safirasaloes.com.br",
      from_name: "SafiraSalões",
      subject: "Uma surpresa aguarda você no #{prNome}",
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
                              { name: 'url', content: registrationURL },
                              { name: 'prof_name', content: prNome },
                              { name: 'service_name', content: serviceNome },
                              { name: 'data_inicio', content: dataInicio },
                              { name: 'hora_inicio', content: horaInicio },
                            ]
                      }
                  ]
    }
  end
end