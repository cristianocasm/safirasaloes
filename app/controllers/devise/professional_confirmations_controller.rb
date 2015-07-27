class Devise::ProfessionalConfirmationsController < Devise::ConfirmationsController

  protected

  def after_confirmation_path_for(resource_name, resource)
    new_session_path(resource_name, email_confirmado: true)
  end
end