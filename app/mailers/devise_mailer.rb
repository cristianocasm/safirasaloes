class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def confirmation_instructions(record, token, opts={})
    email = record.email
    url = confirmation_url(record, :confirmation_token => token)
    subject = "Instruções de Confirmação"
    templateName = "professional_confirmation_instructions"

    DeviseMailerWorker.perform_async(email, url, templateName, subject)
  end

  def reset_password_instructions(record, token, opts={})
    email = record.email
    url = edit_password_url(record, :reset_password_token => token)
    subject = "Instruções para Alteração de Senha"
    templateName = "reset_password_instructions"

    DeviseMailerWorker.perform_async(email, url, templateName, subject)
  end

end