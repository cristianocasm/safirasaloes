class ConfirmationInstructionsWorker
  include Sidekiq::Worker

  sidekiq_options retry: true

  def perform()
    mandrill = Mandrill::API.new(ENV["MANDRILL_PASSWORD"])
    templateName = "professional_confirmation_instructions"
    async = false
    message = generate_message(email, url)

    result = mandrill.messages.send_template(
                                             templateName,
                                             nil,
                                             message,
                                             async
                                            )
  end

  def generate_message(email, url)
    {
      from_email: "contato@safirasaloes.com.br",
      from_name: "SafiraSalões",
      subject: "Instruções de Confirmação",
      to: [ { email: email } ],
      track_opens: false,
      track_clicks: false,
      inline_css: false,
      preserve_recipients: false,
      tracking_domain: 'stats.safirasaloes.com.br',
      merge: true,
      merge_vars: [ {
                      rcpt: email,
                      vars: [ 
                              { name: 'email', content: email },
                              { name: 'url', content: url }
                            ]
                      }
                  ]
    }
  end
end