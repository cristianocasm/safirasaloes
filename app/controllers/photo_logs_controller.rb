class PhotoLogsController < ApplicationController
  before_action :set_photo_log, only: [:destroy]

  # GET /photo_logs
  # GET /photo_logs.json
  def index
    @photo_logs = current_customer.photo_logs.not_posted

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photo_logs.map{|photo| photo.to_jq_upload } }
    end
  end

  # GET /photo_logs/new
  def new
    if current_customer.can_send_photo?
      @photoLog = current_customer.photo_logs.new
      @scs = current_customer.schedules_not_more_than_12_hours_ago
    else
      redirect_to customer_root_path, flash: { error: "Você não foi atendido por um profissional nas últimas 12 horas e, por isso, ainda não pode enviar fotos." }
    end
  end

  # POST /photo_logs
  # POST /photo_logs.json
  def create
    @photoLog = current_customer.photo_logs.create(photo_log_params)

    respond_to do |format|
      if @photoLog.persisted?
        format.html {
          render :json => [@photoLog.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@photoLog.to_jq_upload]}, status: :created, location: @photoLog }
      else
        format.html { render action: "new" }
        format.json { render json: @photoLog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_logs/1
  # DELETE /photo_logs/1.json
  def destroy
    @photo_log.destroy
    respond_to do |format|
      format.html { redirect_to photo_logs_url, notice: 'Photo log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_log
      @photo_log = PhotoLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_log_params
      params.require(:photo_log).permit(:image, :description, :schedule_id)
    end
end
