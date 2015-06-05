class CustomerOmniauthCallbacksController < Devise::OmniauthCallbacksController
   def facebook
    current_customer.save_provider_uid(request.env["omniauth.auth"])
    postedPhotos = post(pendingPostings).try(:compact)
    rwd = current_customer.get_rewards_by(postedPhotos) unless postedPhotos.blank?

    msg = "PARABÉNS! Suas fotos foram enviadas com sucesso. "
    msg = msg + "Recompensa ganha: #{rwd}" unless rwd.zero?

    flash[:success] = msg
    redirect_to customer_root_path, flash: { success: msg }
  end

  private

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