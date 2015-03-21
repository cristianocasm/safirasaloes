class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_professional!, :authorize
  before_filter :configure_permitted_parameters, if: :devise_controller?
  delegate :allow?, :forçar_cadastro_dos_dados_de_contato?, :forcar_cadastro_de_servico?, to: :current_permission
  helper_method :allow?, :flash_errors, :current_resource
  
  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:nome, :telefone, :whatsapp, :pagina_facebook, :rua, :numero, :bairro, :complemento, :cidade, :estado, :site, :email, :password, :password_confirmation, :current_password) }
  end

  def layout_by_resource
    if resource_name == :professional
      devise_controller? && params[:controller] != 'devise/registrations' && params[:action] != "edit" ? "login" : "professional"
    elsif resource_name == :customer
      devise_controller? ? "login" : "customer"
    end
  end

  def flash_errors(obj)
    errorList = "<h4>Os seguintes erros ocorreram:</h4>"
    obj.errors.full_messages.each do |message|
      errorList += "<li>#{message}</li>"
    end
    "<ul>#{errorList}</ul>".html_safe
  end

  private

  def current_permission
    @current_permission ||= Permission.new(current_resource)
  end

  def authorize
    if current_permission.forçar_cadastro_dos_dados_de_contato?(params[:controller], params[:action])
      redirect_to edit_professional_registration_path, flash: { success: 'Seja bem vindo ao Safira Salões!!! Para utilizar todos os recursos que fornecemos cadastre abaixo suas Informações de Contato e visualize o resultado de suas alterações no simulador. ATENÇÃO: SALVE SUAS INFORMAÇÕES DE CONTATO PARA PROSSEGUIR.' }
      return
    elsif current_permission.forcar_cadastro_de_servico?(params[:controller], params[:action])
      redirect_to new_service_path, flash: { success: "Quase acabando... Como último passo para utilizar o sistema, cadastre abaixo um dos seus serviços. Isso lhe permitirá utilizar a agenda do Safira Salões - a qual será sua grande amiga daqui pra frente :D" }
      return
    end
    
    if !allow?(params[:controller], params[:action])
      redirect_to root_url, alert: "Não autorizado."
    end
  end

  def current_resource
    @resource ||= resource_name
    self.send "current_#{@resource}"
  end

  def resource_name
    warden.config[:default_scope]
  end
end