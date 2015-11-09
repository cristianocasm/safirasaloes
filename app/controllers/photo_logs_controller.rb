class PhotoLogsController < ApplicationController
  before_action :set_photo_log, only: [:destroy]
  layout "login"#, only: [:new, :index]

  # GET /photo_logs
  # GET /photo_logs.json
  def index
    @photo_logs = if (ctm = current_customer)
      current_customer.photo_logs.not_posted # levar em consideração aqui o schedule correto
    else
      photo_ids = session[:photo_ids]
      schedule_id = session[:schedule_id]
      PhotoLog.find_not_posted_by_ids_and_schedule(photo_ids, schedule_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photo_logs.map{|photo| photo.to_jq_upload } }
    end
  end

  # GET /photo_logs/new
  def new
    if invited?
      @schedule = Schedule.find_by_id(@sc)
      if @schedule
        @ctNome = @schedule.nome_cliente
        @professional = @schedule.professional
        @can_send_photo = @schedule.can_send_photo?
        session[:schedule_id] = @sc
        notice_woopra() if Rails.env.production?
      else # Trata caso onde profissional deleta esse agendamento
        @can_send_photo = :no
      end
    end
  end

  # POST /photo_logs
  # POST /photo_logs.json
  def create
    @photoLog = PhotoLog.create(photo_log_params)
    
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

    def invited?
      @sc = @token = nil
      if params[:s]
        @sc = params[:s][ 4...params[:s].size]
        @token = params[:s][0..3]
      end

      CustomerInvitation.find_by_schedule_and_token(@sc, @token).present?
    end

    def notice_woopra
      woopra = WoopraTracker.new(request)
      woopra.config( domain: "safirasaloes.com.br" )
      case @can_send_photo
      when :yes; woopra.track('divulgating', { when: 'durante', step: 0 }, true)
      when :future; woopra.track('divulgating', { when: 'antes', step: 0 }, true)
      when :past; woopra.track('divulgating', { when: 'depois', step: 0 }, true)
    end
end
