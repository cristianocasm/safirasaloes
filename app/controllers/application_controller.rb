include WoopraRailsSDK

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate!, :authorize
  before_filter :configure_permitted_parameters, if: :devise_controller?
  delegate :allow?, :forçar_cadastro_dos_dados_de_contato?, :forcar_cadastro_de_servico?, to: :current_permission
  helper_method :allow?, :flash_errors, :current_resource
  
  layout :layout_by_resource

  protected

  def after_sign_in_path_for(resource)
    track_signup_event(resource) if Rails.env.production? && resource.sign_in_count == 1
    track_login_event(resource) if Rails.env.production?
    
    if resource.instance_of?(Customer) && resource.can_send_photo?
      flash.clear
      flash[:success] = "Parabéns! Você está habilitado a enviar as fotos do serviço prestado e GANHAR SAFIRAS!"
      new_photo_log_path
    else
      super
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:nome, :telefone, :whatsapp, :pagina_facebook, :cep, :rua, :numero, :bairro, :complemento, :cidade, :estado, :site, :email, :password, :password_confirmation, :current_password) }
  end

  def layout_by_resource
    if devise_controller? && params[:controller].in?(%w[devise/sessions]) && params[:action].in?(%w[new create])
      "admin/login_admin"
    elsif devise_controller? && ( !params[:controller].in?(%w[devise/professional_registrations]) || !params[:action].in?(%w[edit update]) )
      "login"
    else
      case resource_name
      when :professional; "professional/professional"
      when :customer; "customer/customer"
      when :admin; "admin/admin"
      end
    end
  end

  def flash_errors(obj)
    errorTitle = "<h4>Os seguintes erros ocorreram:</h4>"
    errorList = ""

    obj.errors.full_messages.each do |message|
      errorList += "<li>#{message}</li>"
    end
    "#{errorTitle}<ul>#{errorList}</ul>"
  end

  private

  def track_login_event(resource)
    if resource.instance_of?(Professional)
        woopra = WoopraTracker.new(request)
        woopra.config( domain: "safirasaloes.com.br" )
        woopra.identify(
          email: resource.email,
          name: resource.nome,
          user_type: 'professional',
          professional_plan: resource.status.nome.capitalize,
          telefone: resource.telefone,
          whatsapp: resource.whatsapp,
          avatar: resource.avatar_url
        )
        woopra.track('professional_login', {}, true)
      elsif resource.instance_of?(Customer)
        woopra = WoopraTracker.new(request)
        woopra.config( domain: "safirasaloes.com.br" )
        woopra.identify(
          email: resource.email,
          user_type: 'customer'
        )
        woopra.track('customer_login', {}, true)
      end
  end

  def track_signup_event(resource)
    woopra = WoopraTracker.new(request)
    woopra.config( domain: "safirasaloes.com.br" )
    woopra.identify(
      email: resource.email,
      user_type: 'professional',
      professional_plan: resource.status.nome.capitalize,
      avatar: resource.avatar_url
    )
    woopra.track('professional_signed_up', { plan: 'trial' }, true)
  end

  def authenticate!
    self.send "authenticate_#{resource_name}!" unless ( controller_name.in?(%w[static_pages notifications]) )
  end

  def current_permission
    @current_permission ||= Permission.new(current_resource)
  end

  def authorize
    if current_permission.forçar_cadastro_dos_dados_de_contato?(params[:controller], params[:action])
      redirect_to edit_professional_registration_path, flash: { success: 'Seja bem vindo!!! Como primeiro passo para utilizar todos os recursos que fornecemos, cadastre abaixo suas Informações de Contato e visualize o resultado de suas alterações instantaneamente no simulador.' }
      return
    elsif current_permission.forcar_cadastro_de_servico?(params[:controller], params[:action])
      redirect_to new_service_path, flash: { success: "Como último passo para utilizar o sistema, cadastre abaixo um dos seus serviços. Isso lhe permitirá utilizar a agenda do Safira Salões - a qual será sua grande amiga daqui pra frente :D" }
      return
    end
    
    unless allow?(params[:controller], params[:action])
      if current_resource.instance_of? Professional
        redirect_to professional_root_url, alert: "Não autorizado."
      elsif current_resource.instance_of? Customer
        redirect_to customer_root_url, alert: "Não autorizado."
      else
        redirect_to root_url, alert: "Não autorizado."
      end
    end
  end

  def current_resource
    @resource ||= resource_name
    self.send "current_#{@resource}" if @resource
  end

  def resource_name
    @resource_name ||= 
      if (request.path =~ /^\/profissional/)
        :professional
      elsif (request.path =~ /^\/cliente/)
        :customer
      elsif (request.path =~ /^\/admin/)
        :admin
      end
  end
end