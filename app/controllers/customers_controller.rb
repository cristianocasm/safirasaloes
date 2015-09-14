class CustomersController < Devise::RegistrationsController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    if invited?
      super
    else
      redirect_to root_path, flash: { error: 'Para cadastrar-se como cliente, você deve ser convidado. Caso tenha recebido o convite, certifique-se de acessar usando o link enviado para seu telefone.' }
    end
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    if invited?
      super
    else
      redirect_to :back, flash: { error: 'Não encontramos convite para os dados fornecidos.' }
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # # POST "/customers/filter"
  # def filter_by_email
  #   ctms = Customer.filter_by_email(params[:e])
  #   respond_to do |format|
  #     format.json { render json: ctms.to_json, status: :ok }
  #   end
  # end

  # def filter_by_telefone
  #   ctms = Customer.filter_by_telefone(params[:t])
  #   respond_to do |format|
  #     format.json { render json: ctms.to_json, status: :ok }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:email, :password, :password_confirmation, :schedule_invitation)
    end

    def invited?
      @sc = params[:s] || customer_params[:schedule_invitation]
      @token = params[:t]

      CustomerInvitation.find_by_schedule_and_token(@sc, @token).present?
    end
end
