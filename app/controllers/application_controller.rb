class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_professional!, :authorize#, :check_status
  delegate :allow?, to: :current_permission
  helper_method :allow?
  
  layout :layout_by_resource

  protected

  def layout_by_resource
    devise_controller? && resource_name == :professional ? "login" : "application"
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
    if !current_permission.allow?(params[:controller], params[:action])
      redirect_to root_url, alert: "Não autorizado."
    end
  end

  def current_resource
    resource = warden.config[:default_scope]
    self.send "current_#{resource}"
  end
end