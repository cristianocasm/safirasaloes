class DeviseMailerWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  # Necessário para que Customer seja capaz de
  # acessar 'meus_serviços' logo após o cadastro
  # e visualizar os serviços fornecidos pelo
  # profissional que o convidou.
  def perform(email, url, templateName, subject)
    mandrill = Mandrill::API.new(ENV["MANDRILL_PASSWORD"]).messages
    async = false
    message = generate_message(email, url, subject)
    
    mandrill.send_template(templateName, nil, message, async)
  end

  def generate_message(email, url, subject)
    {
      from_email: "contato@safirasaloes.com.br",
      from_name: "SafiraSalões",
      subject: subject,
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