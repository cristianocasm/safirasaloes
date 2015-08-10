class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env['omniauth.params']
    
    if auth['action'] == 'signup_or_signin'
      signup_or_signin_with_facebook
    elsif auth['action'] == 'publish_photos'
      publish_photos
    end
  end
 
private
  
  # Função abaixo procura por profissional ou cliente com um
  # dado ( ( provider e uid ) ou e-mail ). Caso não encontre
  # ele cadastra como profissional o visitante e o redireciona
  # para a área logada.
  def signup_or_signin_with_facebook
    auth = request.env["omniauth.auth"]
    resource = Professional.find_by_provider_and_uid_or_email(auth.provider, auth.uid, auth.info.email) ||
                  Customer.find_by_provider_and_uid_or_email(auth.provider, auth.uid, auth.info.email).try(:first) ||
                  Professional.create_with_omniauth(auth)
    resource_name = resource.class.to_s.downcase.to_sym
    sign_in(resource_name, resource)
    redirect_to after_sign_in_path_for(resource)
  end

  # Função abaixo publica as fotos do cliente no Facebook e fornece
  # a devida recompensa.
  def publish_photos
    current_customer.save_provider_uid(request.env["omniauth.auth"])
    pendingPostings = current_customer.photo_logs.not_posted
    postedPhotos = post(pendingPostings).try(:compact)
    rwd = current_customer.get_rewards_by(postedPhotos) unless postedPhotos.blank?

    msg = "PARABÉNS! Suas fotos foram enviadas com sucesso. "
    msg = msg + "Recompensa ganha: #{rwd}" unless rwd.zero?

    flash[:success] = msg
    redirect_to customer_root_path, flash: { success: msg }
  end

  def post(pendingPostings)
    prof = pendingPostings.first.schedule.professional
    pendingPostings.each do |photo|
      begin
        photo.submit_to_fb(prof)
      rescue Koala::Facebook::APIError => e
        logger.info e.to_s
        nil
      end
    end
  end
end