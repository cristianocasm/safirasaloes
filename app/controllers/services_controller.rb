include WoopraRailsSDK

class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    # @step_taken = current_professional.taken_step.tela_listagem_servicos_acessada?
    # current_professional.update_taken_step(tela_listagem_servicos_acessada: true) unless @step_taken
    @services = current_professional.services_ordered
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    # @step_taken = current_professional.taken_step.tela_cadastro_servico_acessada?
    # current_professional.update_taken_step(tela_cadastro_servico_acessada: true) unless @step_taken
    @service = Service.new
    @service.prices.build
  end

  # GET /services/1/edit
  def edit
    # @step_taken = current_professional.taken_step.tela_edicao_servico_acessada?
    # current_professional.update_taken_step(tela_edicao_servico_acessada: true) unless @step_taken
  end

  # POST /services
  # POST /services.json
  def create
    @service = current_professional.services.new(service_params)

    if @service.save
      unless current_professional.taken_step.servico_cadastrado?
        
        if Rails.env.production?
          woopra = WoopraTracker.new(request)
          woopra.config( domain: "safirasaloes.com.br" )
          woopra.track('professional_created_service', {}, true)
        end
        
        current_professional.update_taken_step(servico_cadastrado: true)
      end
      redirect_to @service, flash: { success: generate_msg }
    else
      flash.now[:error] = flash_errors(@service)
      render :new
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    if @service.update(service_params)
      redirect_to @service, flash: { success: generate_msg }
    else
      flash.now[:error] = flash_errors(@service)
      render :edit
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    msg = if @service.destroy
      { flash: { success: 'Serviço excluído com sucesso.' } }
    else
      { flash: { error: 'Serviço não foi excluído devido à existência de horários marcados para ele.' } }
    end
      redirect_to services_url, msg
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
      params.require(:service).permit(:nome, :preco_fixo, prices_attributes: [:id, :descricao, :preco, :recompensa_divulgacao, :_destroy])
    end

    def generate_msg
      "
      <p>
        Parabéns! Você pode agora <a href='#{professional_root_path(servico: @service.prices.first.id)}' style='text-decoration: underline'>estimular a divulgação boca-a-boca de '#{@service.nome}' clicando aqui</a>.
      </p>
      "
    end
end
