class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = current_professional.services_ordered
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = current_professional.services.new(service_params)

    if @service.save
      redirect_to @service, flash: { success: 'Serviço criado com sucesso.' }
    else
      flash[:error] = flash_errors(@service)
      render :new
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    if @service.update(service_params)
      redirect_to @service, flash: { success: 'Serviço atualizado com sucesso.' }
    else
      flash[:error] = flash_errors(@service)
      render :edit
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    redirect_to services_url, flash: { success: 'Serviço excluído com sucesso.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = current_professional.services.find_by_id(params[:id])
      if @service.blank?
        redirect_to services_url, flash: { error: 'Serviço não encontrado' }
      else
        @service
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:nome, :preco, :recompensa_divulgacao)
    end
end
