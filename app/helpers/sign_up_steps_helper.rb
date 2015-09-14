module SignUpStepsHelper
  def resource_name
    :professional
  end

  def resource
    @resource ||= current_professional
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:professional]
  end
end