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

  def toggle_resource_name(lang = 'en')
    if resource_name == :customer
      return :professional if lang == 'en'
      return :profissional if lang == 'pt'
    elsif resource_name == :professional
      return :customer if lang == 'en'
      return :cliente if lang == 'pt'
    end
  end
end