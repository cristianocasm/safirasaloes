class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy, :show_invitation_template]

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
    current_professional.update_taken_step(tela_cadastro_horario_acessada: true)
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
    if @schedule.save
      flash[:success] = generate_success_msg(@schedule)
      current_professional.update_taken_step(horario_cadastrado: true)
    else
      flash.now[:error] = flash_errors(@schedule)
    end

    respond_to do |format|
      format.js { render 'new_schedule' }
    end
  end

  def show_invitation_template
    respond_to do |format|
      format.js { render 'show_invitation_template' }
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
      data = params.
              require(:schedule).
              permit(
                :id,
                :customer_id,
                :price_id,
                :nome,
                :email,
                :telefone,
                :datahora_inicio,
                :datahora_fim,
                :observacao,
                :pago_com_safiras
              )
    end

    def generate_success_msg(sc)
      msg = I18n.t('schedule.created.success') + "<br/>"
      if sc.email.present?
        msg += I18n.t('schedule.created.customer.invited', nome_servico: sc.price.nome) + " "
        msg += I18n.t('schedule.created.customer.invitation_template', link: show_invitation_template_schedule_path(sc))
      else
        msg += I18n.t('schedule.created.customer.not_invited', nome_servico: sc.price.nome) + " "
        msg += I18n.t('schedule.created.customer.set_email', link: edit_schedule_path(sc))
      end
    end
end
