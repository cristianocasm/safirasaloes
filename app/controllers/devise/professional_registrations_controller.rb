class Devise::ProfessionalRegistrationsController < Devise::RegistrationsController

  def edit
    current_professional.update_taken_step(tela_cadastro_contato_acessada: true)
    super
  end

  # Permite a definição das informações de contato sem 
  # a informação da senha
  protected

  def update_resource(resource, params)
    current_professional.update_taken_step(contato_cadastrado: true) if resource.update_without_password(params)
  end
end