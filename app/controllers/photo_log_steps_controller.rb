class PhotoLogStepsController < ApplicationController
  include Wicked::Wizard
  steps :photos, :comments, :professional_info, :fb_permission, :revision

  def show
    case step
    when :photos
      if current_customer.can_send_photo?
        @photoLog = current_customer.photo_logs.new
        @scs = current_customer.schedules_not_more_than_12_hours_ago
      else
        redirect_to customer_root_path, flash: { error: "Você não foi atendido por um profissional nas últimas 12 horas e, por isso, ainda não pode enviar fotos." }
        return
      end
    when :comments
    when :professional_info
    when :fb_permission
    when :revision
    end
    
    # @user = current_user
    render_wizard
  end
  
  # def update
  #   @user = current_user
  #   @user.attributes = params[:user]
  #   render_wizard @user
  # end
end
