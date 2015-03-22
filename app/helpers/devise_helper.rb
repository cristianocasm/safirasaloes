module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    flash[:error] = flash_errors(resource)
  end

  def label_name
    if resource_name == :professional
      "profissional"
    elsif resource_name == :customer
      "cliente"
    end
  end

  def toggle_resource_name
    return :professional if resource_name == :customer
    return :customer if resource_name == :professional
  end
end