class CustomerOmniauthCallbacksController < Devise::OmniauthCallbacksController
   def facebook
    @customer = current_customer.save_provider_uid(request.env["omniauth.auth"])

    current_customer.
      facebook.
      put_picture(
        '/home/cristiano/Imagens/Cristiano.jpg',
        { :message => Schedule.append_professional_info }
      )
    # Permissão de escrita foi dada?
      # postar foto no Facebook
    # else
      # retornar com erro
    redirect_to new_photo_log_path
  end
end