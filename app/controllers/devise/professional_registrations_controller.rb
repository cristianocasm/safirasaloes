include WoopraRailsSDK

class Devise::ProfessionalRegistrationsController < Devise::RegistrationsController

  def edit
    @step_taken = current_professional.taken_step.tela_cadastro_contato_acessada?
    current_professional.update_taken_step(tela_cadastro_contato_acessada: true) unless @step_taken
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => ( /sign_up_steps/.match(request.referer) ? after_update_path_for(resource) : edit_professional_registration_path )
    else
      clean_up_passwords resource
      flash[:error] = flash_errors(resource)
      redirect_to :back
    end
  end

  # Permite a definição das informações de contato sem 
  # a informação da senha
  protected

  def update_resource(resource, params)
    if (persisted = resource.update_without_password(params)) && !resource.taken_step.contato_cadastrado?
    
      if Rails.env.production?
        woopra = WoopraTracker.new(request)
        woopra.config( domain: "safirasaloes.com.br" )
        woopra.track('professional_defined_contact', {}, true)
      end
      
      resource.update_taken_step(contato_cadastrado: true)
    end
    persisted
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
    
    flash.clear
    sign_up_steps_path
  end
end