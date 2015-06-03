class PhotoLogStepsController < ApplicationController
  include Wicked::Wizard
  steps :comments, :professional_info, :fb_permission, :revision

  def show
    case step
    when :comments
      @photos = PhotoLog.find(params['photos'])
      unless @photos.present?
        redirect_to :back, flash: { error: 'Carregue pelo menos 1 foto.' } and return
      end
    when :professional_info
      @photos = current_customer.photo_logs.where(id: params['photo_logs'])
      @prof_info = @photos.first.schedule.professional.contact_info
    when :fb_permission
    when :revision
    end
    
    render_wizard
  end
  
  def update
    ids = []

    params["photo_logs"].each do |key, val|
      pl = current_customer.photo_logs.find_by_id(key)

      if pl.present?
        pl.update_attribute(:description, val["description"])
        ids << key
      end
    end

    redirect_to next_wizard_path(photo_logs: ids)
  end
end
