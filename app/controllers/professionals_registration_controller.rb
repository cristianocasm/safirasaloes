class ProfessionalsRegistrationController < Devise::RegistrationsController

  # Permite a definição das informações de contato sem 
  # a informação da senha
  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end