class CustomerOmniauthCallbacksController < Devise::OmniauthCallbacksController
   def facebook
    current_customer.save_provider_uid(request.env["omniauth.auth"])
    #current_customer.photo_logs.not_posted.map { |photo| photo.submit_to_fb }
    redirect_to new_photo_log_path
  end
end