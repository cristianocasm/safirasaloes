class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    # try to authenticate as a Professional
    self.resource = warden.authenticate(auth_options)
    resource_name = self.resource_name
 
    if resource.nil?
      # try to authenticate as a Customer
      resource_name = :customer
      request.params[:customer] = params[:professional]
 
      self.resource = warden.authenticate!(auth_options.merge(scope: :customer))
    end
 
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  def destroy
    super
  end
end