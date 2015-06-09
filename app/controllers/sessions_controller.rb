class SessionsController < Devise::SessionsController
  def new
    if customer_signed_in?
      if current_customer.can_send_photo?
        redirect_to new_photo_log_path, flash: { success: "Parabéns! Você está habilitado a enviar as fotos do serviço prestado e GANHAR SAFIRAS!" }
      else
        redirect_to customer_root_path
      end
    else
      super
    end
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