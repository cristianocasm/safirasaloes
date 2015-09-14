include WoopraRailsSDK

class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]

  # GET /schedules
  # GET /schedules.json
  def index
    start = params['start']
    hend  = params['end'] # hend, pois end é uma palavra reservada
    schedules = current_professional.schedules_to_calendar(start, hend)
    render json: schedules
  end

  # GET /schedules/1
  # Profissional não tem a opção de consultar
  # um horário através do método show (tudo
  # é feito com o index e edit). Assim, caso
  # ele tente fazer a consulta (inserindo
  # a url no browser), será redirecionado para
  # a agenda.
  def show
    redirect_to professional_root_url
  end

  # GET /schedules/new
  def new
    @step_taken = current_professional.taken_step.tela_cadastro_horario_acessada?
    unless @step_taken
      
      if Rails.env.production?
        woopra = WoopraTracker.new(request)
        woopra.config( domain: "safirasaloes.com.br" )
        woopra.track('professional_accessed_schedule_page', {}, true)
      end

      current_professional.update_taken_step(tela_cadastro_horario_acessada: true)
    end
    @schedule = Schedule.new
    @schedule.build_price if current_professional.creating_first_service?
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
    set_price_on_schedule if current_professional.creating_first_service?
    if @schedule.save
      flash.now[:success] = generate_success_msg(@schedule)

      unless current_professional.taken_step.horario_cadastrado?
      
        if Rails.env.production?
          woopra = WoopraTracker.new(request)
          woopra.config( domain: "safirasaloes.com.br" )
          woopra.track('appointment_scheduled', {}, true)
        end
        
        current_professional.update_taken_step(horario_cadastrado: true)
      end
    else
      flash.now[:error] = flash_errors(@schedule)
    end

    respond_to do |format|
      format.js { render 'new_schedule' }
    end
  end

  # def show_invitation_template
  #   respond_to do |format|
  #     format.js { render 'show_invitation_template' }
  #   end
  # end

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
    @myProfs = current_customer.my_professionals.includes(services: [:prices])
    flash.now[:success] = "Suas fotos foram enviadas com sucesso. Obrigado!" if params[:photo_sent].present?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = current_professional.schedules.find_by_id(params[:id])
      if @schedule.blank?
        render nothing: true
      else
        @schedule
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.
        require(:schedule).
        permit(
          :id,
          :customer_id,
          :price_id,
          :nome,
          :telefone,
          :datahora_inicio,
          :datahora_fim,
          :observacao,
          :pago_com_safiras,
          :price_attributes => [:on_schedule_form]
        )
    end

    def service_params
      params.
        require(:schedule).
        require(:price_attributes).
        require(:service).
        permit(:nome)
    end

    def generate_success_msg(sc)
      msg = I18n.t('schedule.created.success') + "<br/>"
      if sc.telefone.present?
        msg += I18n.t('schedule.created.customer.invited', nome_servico: sc.price.nome) #+ " "
        # msg += I18n.t('schedule.created.customer.invitation_template', link: show_invitation_template_schedule_path(sc))
      else
        msg += I18n.t('schedule.created.customer.not_invited', nome_servico: sc.price.nome) + " "
        msg += I18n.t('schedule.created.customer.set_telefone', link: edit_schedule_path(sc))
      end
    end

    def set_price_on_schedule
      @schedule.price.tap { |p| p.service = Service.new(service_params) }
      set_professional_on_service if @schedule.price.service.professional_id.nil?
    end

    def set_professional_on_service
      @schedule.price.service.professional = current_professional
    end
end
