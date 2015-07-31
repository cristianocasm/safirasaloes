include WoopraRailsSDK

class Devise::ProfessionalConfirmationsController < Devise::ConfirmationsController

  protected

  # Registra no woopra evento relacionado à confirmação
  # do e-mail do profissional e o redireciona para a
  # home page - local no qual ele é avisado sobre o
  # sucesso da confirmação e onde ele pode fazer login.
  def after_confirmation_path_for(resource_name, resource)
    if Rails.env.production?
      woopra = WoopraTracker.new(request)
      woopra.config( domain: "safirasaloes.com.br" )
      woopra.track('professional_confirmed_email', {}, true)
    end

    new_session_path(resource_name)
  end
end