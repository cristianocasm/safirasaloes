class PhotosController < ApplicationController
  before_action :set_photo, only: [:destroy]
  layout Proc.new {
    if params[:action] == 'index'
      if current_customer.present?
        'customer/customer'
      else
        'login'
      end
    elsif params[:action] == 'my_site'
        'professionals_site/professional_site'
    else
      'professional/professional'
    end
  }

  # GET /photo
  # GET /photo.json
  def index
    ci = CustomerInvitation.find_by_token(params[:token])

    if ci.present?
      byebug
      if already_signed_but_not_logged_in?(ci.customer)
        sign_out(current_customer) if current_customer # desloga se outro cliente estiver logado
        session[:previous_url] = request.fullpath      # guarda link para divulgação para redirecionar devolta após o login
        flash[:error] = "#{ci.customer.nome}, faça login para que sua recompensa seja salva após a divulgação"
        redirect_to new_customer_session_path(customer: true)
      else
        @photos = ci.photos
        @professional =  @photos.first.professional
      end

    else
      render 'static_pages/error_404', layout: false
    end

  end

  # GET /photo/new
  def new
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

  def my_site
    @professional = Professional.find(params[:slug])
    @photos = @professional.photos
    
    # instrução abaixo garante que acesso sempre se dará na URL correta (atual) mesmo se
    # profissional tiver mudado seu slug
    redirect_to professionals_site_path(@professional), status: :moved_permanently if request.path != professionals_site_path(@professional)

    rescue ActiveRecord::RecordNotFound => e
      render 'static_pages/error_404', layout: false
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
      params.require(:invitation).permit(:customer_telefone, :recompensa, :get_safiras, :customer_id, photo_ids: [])
    end

    def already_signed_but_not_logged_in?(customer)
      customer.present? && customer != current_customer
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
