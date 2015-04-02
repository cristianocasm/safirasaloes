class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  # GET /schedules
  # GET /schedules.json
  def index
    start = params['start']
    hend  = params['end'] # hend, pois end é uma palavra reservada
    schedules = current_professional.schedules_to_calendar(start, hend)
    render json: schedules
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit
    respond_to do |format|
      format.js { render 'edit_schedule' }
    end
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.find_or_initialize_by(id: schedule_params[:id])
    @schedule.assign_attributes(schedule_params)
    unless @schedule.save
      flash.now[:error] = flash_errors(@schedule) 
    end
    respond_to do |format|
      format.js { render 'new_schedule' }
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    if @schedule.update(schedule_params)
      render json: @schedule, status: :ok, location: @schedule
    else
      render json: @schedule.errors, status: :unprocessable_entity
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.js { render 'flush_fullcalendar' }
    end
  end

  # POST /schedules/get_last_two_months_scheduled_customers
  def get_last_two_months_scheduled_customers
    ctms = Schedule.get_last_two_months_scheduled_customers(current_professional.id)
    respond_to do |format|
      format.json { render json: ctms.to_json, status: :ok }
    end
  end

  # Methods for ExchangeOrder
  def new_exchange_order
    @future_schedules = current_customer.future_schedules
    @my_professionals = current_customer.my_professionals
  end

  def create_exchange_order
    @sc = current_customer.schedules.includes(:service, :professional).find_by_id(exchange_order_params[:schedule_id]) # verificar se está no futuro tbm
    respond_to do |format|
      if @sc.present?
        preco = @sc.service.preco
        reward = current_customer.rewards.where(professional: @sc.professional)
        if reward.present? && reward.first.total_safiras > preco
          if # solicitação não enviada
            @sc.update_attribute(:exchange_order_status_id, ExchangeOrderStatus.find_by_nome('aguardando').id)
            @professional_id = @sc.professional.id
            format.js { render 'create_exchange_order' }
          else
            # retorna error -> Solicitação de troca já foi criada
          end
        else
          #retorna erro -> Safiras insuficiente
        end
      else
        #retorna erro -> Horário inexistente
      end
    end
  end

  def accept_exchange_order
    _params = accept_exchange_order_params
    @schedule_id = _params[:schedule_id]
    @sc = Schedule.includes(:customer, :service).find_by_id(@schedule_id)
    
    if @sc.present?
      if _params[:status] == 'accept'
        @sc.update_attribute(:exchange_order_status_id, ExchangeOrderStatus.find_by_nome('aceita').id)
      elsif _params[:status] == 'reject'
        @sc.update_attributes(
          exchange_order_status_id: ExchangeOrderStatus.find_by_nome('recusada').id,
          motivo_recusa: _params[:motivo_recusa]
          )
      end
    end
    
    # Falta debitar Safiras Bloqueadas do cliente

    respond_to do |format|
      format.js { render 'destroy_exchange_order' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      data = params.require(:schedule)
      data = data.permit(:id, :customer_id, :service_id, :nome, :email, :telefone, :datahora_inicio, :datahora_fim, :observacao)
      data.merge!(professional_id: current_professional.id)
      data.merge!(recompensa_divulgacao: Service.find_by_id(params[:schedule][:service_id]).try(:recompensa_divulgacao))
    end

    def exchange_order_params
      params.require(:exchange_order).permit(:schedule_id)
    end
    
    def accept_exchange_order_params
      params.require(:exchange_order).permit(:motivo_recusa, :schedule_id, :status)
    end

end
