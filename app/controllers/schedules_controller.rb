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
    @schedule = current_professional.schedules.find_or_initialize_by(id: schedule_params[:id])
    @schedule.assign_attributes(schedule_params)    
    flash.now[:error] = flash_errors(@schedule) unless @schedule.save

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

  def meus_servicos_por_profissionais
    @myProfs = current_customer.my_professionals
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      data = params.
              require(:schedule).
              permit(
                :id,
                :customer_id,
                :service_id,
                :nome,
                :email,
                :telefone,
                :datahora_inicio,
                :datahora_fim,
                :observacao,
                :pago_com_safiras
              )
    end
end
