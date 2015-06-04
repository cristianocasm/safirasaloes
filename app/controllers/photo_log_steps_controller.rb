class PhotoLogStepsController < ApplicationController
  include Wicked::Wizard
  steps :comments, :professional_info, :revision

  def show
    case step
    when :comments
      if_no_photos_redirect_to_first_step and return
    when :professional_info
      if_no_photos_redirect_to_first_step and return
      @prof_info = @photos.first.schedule.professional.contact_info
    when :revision
      if_no_photos_redirect_to_first_step and return
      if params['prof_info_allowed'].present? && params['prof_info_allowed'].in?(%w[true false])
        @prof_info_allowed = params['prof_info_allowed']
        @photos.update_all(prof_info_allowed: params['prof_info_allowed'])
      end
    end
    
    render_wizard
  end
  
  def update
    ids = []

    params["photos"].each do |key, val|
      pl = current_customer.photo_logs.find_by_id(key)

      if pl.present?
        pl.update_attribute(:description, val["description"])
        ids << key
      end
    end

    redirect_to next_wizard_path(photos: ids)
  end

  def finish_wizard_path
    pendingPostings = current_customer.photo_logs.where(id: params['photos'])
    postedPhotos = post(pendingPostings).try(:compact)
    rwd = current_customer.get_rewards_by(postedPhotos) unless postedPhotos.blank?

    msg = "PARABÉNS! Suas fotos foram enviadas com sucesso. "
    msg = msg + "Recompensa ganha: #{rwd}" unless rwd.zero?
    
    flash[:success] = msg
    customer_root_path
  end

  private

  def if_no_photos_redirect_to_first_step
    @photos = current_customer.photo_logs.where(id: params['photos'])
    if @photos.blank?
      redirect_to new_photo_log_path, flash: { error: 'Carregue pelo menos 1 foto.' }
      true
    end
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
