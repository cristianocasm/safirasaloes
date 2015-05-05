class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def confirmation_instructions(record, token, opts={})
    email = record.email
    url = confirmation_url(record, :confirmation_token => token)
    ConfirmationInstructionsWorker.perform_async(email, url)
  end

  def reset_password_instructions(record, token, opts={})
    email = record.email
    url = edit_password_url(record, :reset_password_token => token)
    ResetPasswordInstructionsWorker.perform_async(email, url)
  end
end