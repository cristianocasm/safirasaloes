class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # Função que lida com o retorno do Facebook
  def facebook
    auth = request.env['omniauth.params']
    
    if auth['action'] == 'signup_or_signin'
      signup_or_signin_with_facebook
    elsif auth['action'] == 'signup_customer'
      signup_customer
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
                  Customer.find_by_provider_and_uid(auth.provider, auth.uid).try(:first)
    if resource.present?
      resource_name = resource.class.to_s.downcase.to_sym
      sign_in(resource_name, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      resource = Professional.create_with_omniauth(auth)
      sign_in(:professional, resource)
      track_signup_event(resource) if Rails.env.production?
      redirect_to sign_up_steps_path
    end

  end

  # Função abaixo cadastra o cliente que fez sua primeira divulgação e
  # decidiu cadastrar-se, além de autenticá-lo no sistema
  def signup_customer
    # auth = request.env["omniauth.auth"]
    # params = request.env['omniauth.params']
    
    # # Faz cadastro (se não estiver cadastrado) e o autentica no sistema.
    # customer = Customer.find_by_provider_and_uid(auth.provider, auth.uid).try(:first)
    # customer = Customer.create_with_omniauth(auth, params) unless customer.present?
    # sign_in(:customer, customer)

    # # Publica fotos no Facebook pendingPostings = current_customer.photo_logs.not_posted
    # if customer.fb_publish_action_granted?
    #   pendingPostings = PhotoLog.where(id: params['photos'])
    #   pendingPostings.update_all(customer_id: current_customer.id)
    #   pendingPostings.reload # Garante que atualização acima é refletida nos objetos atualizados
    #   postedPhotos = post(pendingPostings).try(:compact)
    #   rwd = current_customer.get_rewards_by(postedPhotos) unless postedPhotos.blank?

    #   msg = "PARABÉNS! Suas fotos foram postadas no Facebook com sucesso. "
    #   msg = msg + "Recompensa ganha: #{rwd}" unless rwd.zero?

    #   notice_woopra('sim') if Rails.env.production?

    #   redirect_to customer_root_path, flash: { success: msg }
    # else
    #   notice_woopra('não') if Rails.env.production?
    #   redirect_to photo_log_step_path(id: :revision, photos: params['photos'], prof_info_allowed: true), flash: { error: "Para ser recompensado permita que o SafiraSalões poste as fotos em seu perfil." }
    # end
    auth = request.env["omniauth.auth"]
    params = request.env['omniauth.params']
    
    # Faz cadastro (se não estiver cadastrado) e o autentica no sistema.
    # customer = Customer.find_by_provider_and_uid(auth.provider, auth.uid).try(:first)
    customer = Customer.find_by_telefone(params['telefone']).update_with_omniauth(auth, params)
    sign_in(:customer, customer)

    redirect_to customer_root_path, flash: { success: 'Cadastro realizado e recompensas salvas com sucesso.' }
  end

  # def post(pendingPostings)
  #   prof = pendingPostings.first.schedule.professional
  #   pendingPostings.map do |photo|
  #     begin
  #       photo.submit_to_fb(prof)
  #     rescue Koala::Facebook::APIError => e
  #       logger.info "\n\n\n\n\n\n\n\n#{e.to_s}\n\n\n\n\n\n\n\n"
  #       nil
  #     end
  #   end
  # end

  def notice_woopra(published)
    woopra = WoopraTracker.new(request)
    woopra.config( domain: "safirasaloes.com.br" )
    woopra.track('published', { published: published }, true)
  end
end