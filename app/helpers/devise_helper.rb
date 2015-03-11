module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    flash[:error] = flash_errors(resource)
  end
end