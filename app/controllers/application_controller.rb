class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_professional!, :authorize
  before_filter :configure_permitted_parameters, if: :devise_controller?
  delegate :allow?, :forçar_cadastro_dos_dados_de_contato?, :forcar_cadastro_de_servico?, to: :current_permission
  helper_method :allow?, :flash_errors
  
  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:nome, :telefone, :whatsapp, :pagina_facebook, :rua, :numero, :bairro, :complemento, :cidade, :estado, :site, :email, :password, :password_confirmation, :current_password) }
  end

  def layout_by_resource
    #devise_controller? && resource_name == :professional ? "login" : "application"
    devise_controller? && params[:controller] != 'devise/registrations' && params[:action] != "edit" && resource_name == :professional ? "login" : "application"
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
      redirect_to edit_professional_registration_path
      return
    elsif current_permission.forcar_cadastro_de_servico?(params[:controller], params[:action])
      redirect_to new_service_path, success: "Defina seus serviços"
      return
    end
    
    if !allow?(params[:controller], params[:action])
      redirect_to root_url, alert: "Não autorizado."
    end
  end

  def current_resource
    @resource ||= warden.config[:default_scope]
    self.send "current_#{@resource}"
  end
end