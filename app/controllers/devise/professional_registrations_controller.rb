include WoopraRailsSDK

class Devise::ProfessionalRegistrationsController < Devise::RegistrationsController

  def edit
    @step_taken = current_professional.taken_step.tela_cadastro_contato_acessada?
    current_professional.update_taken_step(tela_cadastro_contato_acessada: true) unless @step_taken
    super
  end

  # Permite a definição das informações de contato sem 
  # a informação da senha
  protected

  def update_resource(resource, params)
    resource.tap do |rsc|
      if rsc.update_without_password(params) && !resource.taken_step.contato_cadastrado?
      
        if Rails.env.production?
          woopra = WoopraTracker.new(request)
          woopra.config( domain: "safirasaloes.com.br" )
          woopra.track('professional_defined_contact', {}, true)
        end
        
        resource.update_taken_step(contato_cadastrado: true)
      end
    end
    
  end

  # # Registra no woopra evento relacionado ao cadastro
  # # do profissional no plano free trial e o redireciona
  # # para a home page - local no qual ele é avisado sobre
  # # a necessidade de confirmação do e-mail.
  # def after_inactive_sign_up_path_for(resource)
  #   if Rails.env.production?
  #     woopra = WoopraTracker.new(request)
  #     woopra.config( domain: "safirasaloes.com.br" )
  #     woopra.identify(
  #       email: params[:professional][:email],
  #       user_type: 'professional'
  #     )
  #     woopra.track('professional_signed_up', { plan: 'trial' }, true)
  #   end

  #   new_professional_session_path
  # end

  def after_sign_up_path_for(resource)
    if Rails.env.production?
      woopra = WoopraTracker.new(request)
      woopra.config( domain: "safirasaloes.com.br" )
      woopra.identify(
        email: params[:professional][:email],
        user_type: 'professional'
      )
      woopra.track('professional_signed_up', { plan: 'trial' }, true)
    end
    
    sign_up_steps_path
  end
end