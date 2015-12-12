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
    @ci = CustomerInvitation.find_by_access_token(params[:token])

    if @ci.present?
      generate_flash_message
      @photos = @ci.photos
      @professional =  @ci.professional
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
        @ci = current_professional.customer_invitations.new(customer_invitation_params)

        if @ci.save
          flash.now[:success] = "
          Cliente convidado a divulgar seu trabalho e fotos adicionadas ao seu site. <a href='whatsapp://send?text=#{@ci.customers_whatsapp_message}' class='btn btn-warning btn-block'>Convide-o também via whatsapp</a>"
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
    c = {}
    @photos = @professional.photos.to_a.keep_if { |p, d| !c.has_key?(p.image_fingerprint) and c[p.image_fingerprint] = true  }

    if params[:v].present? && params[:p].present?
      ci = CustomerInvitation.find_by_validation_token(params[:v])
      ci.award_rewards(params[:p]) if ci.present? && !ci.recovered?
    end
    
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

    def generate_flash_message
      btn = get_btn
      msg = get_msg

      flash.now[:alert] = "
        #{get_msg}
        #{btn}
        Se não compartilhou, compartilhe e ganhe safiras!!!!
      "
      
      unless @ci.visto?
        @hidden = 'hidden'
        @ci.visto!
      end
    end

    def get_btn
      url = text = ""

      if current_customer.present?
        url = customer_root_path
        text = "<b>Ver Minhas Safiras</b>"
      else
        url = "/auth/facebook?scope=email&action=signup_customer&telefone=#{@ci.customer_telefone}"
        text = "<i class='fa fa-facebook'></i><b style='padding-left: 20px'>Entre com o Facebook</b>"
      end

      "<a href='#{url}' class='btn btn-fb btn-block normal-white-space mt-10 mb-10'>
        <span style='color: white'>#{text}</span>
      </a>"
    end

    def get_msg
      if current_customer.present?
        "Já compartilhou? Então veja suas safiras"
      else
        "Já compartilhou? Então entre para ver suas safiras"
      end
    end
end
