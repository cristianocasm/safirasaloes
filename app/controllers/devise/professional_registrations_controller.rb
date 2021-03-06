include WoopraRailsSDK

class Devise::ProfessionalRegistrationsController < Devise::RegistrationsController

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    # Instrução necessária para que slug do site do profissional seja alterado
    resource.slug = nil

    if update_resource(resource, account_update_params)
      yield resource if block_given?
      if is_flashing_format? && !cadastrando?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :success, flash_key, link: professional_root_path
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => ( cadastrando? ? after_update_path_for(resource) : edit_professional_registration_path )
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
    if (persisted = resource.update_without_password(params))
    
      if Rails.env.production?
        woopra = WoopraTracker.new(request)
        woopra.config( domain: "safirasaloes.com.br" )
        woopra.track('professional_defined_contact', {}, true)
      end
      
    end
    persisted
  end

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

  def cadastrando?
    @cadastrando ||= /sign_up_steps/.match(request.referer)
  end
end