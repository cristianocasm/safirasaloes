class PhotosController < ApplicationController
  before_action :set_photo, only: [:destroy]
  # layout "login"#, only: [:new, :index]

  # GET /photo
  # GET /photo.json
  def index
    @photos = if (ctm = current_customer)
      current_customer.photos.not_posted # levar em consideração aqui o schedule correto
    else
      photo_ids = session[:photo_ids]
      schedule_id = session[:schedule_id]
      Photo.find_not_posted_by_ids_and_schedule(photo_ids, schedule_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos.map{|photo| photo.to_jq_upload } }
    end
  end

  # GET /photo/new
  def new
    # if invited?
    #   @schedule = Schedule.find_by_id(@sc)
    #   if @schedule
    #     @ctNome = @schedule.nome_cliente
    #     @professional = @schedule.professional
    #     @can_send_photo = @schedule.can_send_photo?
    #     session[:schedule_id] = @sc
    #     notice_woopra() if Rails.env.production?
    #   else # Trata caso onde profissional deleta esse agendamento
    #     @can_send_photo = :no
    #   end
    # end
  end

  # POST /photo
  # POST /photo.json
  def create

    respond_to do |format|
      format.html do
        @ci = CustomerInvitation.new(customer_invitation_params)

        if @ci.save
          flash.now[:success] = 'Cliente convidado a divulgar seu trabalho e fotos adicionadas ao seu site.'
          render :new
        else
          render :new
        end
      end

      format.json do
        @photo = current_professional.photos.new(photo_params)
        
        if @photo.save
          render json: { files: [@photo.to_jq_upload] }, status: :created, location: @photo
        else
          render json: @photo.errors, status: :unprocessable_entity
        end

      end

    end

    # respond_to do |format|
    #   if @photo.persisted?
    #     format.html {
    #       render :json => [@photo.to_jq_upload].to_json,
    #       :content_type => 'text/html',
    #       :layout => false
    #     }
    #     format.json { render json: {files: [@photo.to_jq_upload]}, status: :created, location: @photo }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @photo.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /photo/1
  # DELETE /photo/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:image, :description)
    end

    def customer_invitation_params
      params.require(:invitation).permit(:customer_telefone, :safiras, photo_ids: [])
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
      woopra.identify(email: @professional.email)
      case @can_send_photo
      when :yes; woopra.track('divulgating', { when: 'durante', step: 0 }, true)
      when :future; woopra.track('divulgating', { when: 'antes', step: 0 }, true)
      when :past; woopra.track('divulgating', { when: 'depois', step: 0 }, true)
      end
    end
end
