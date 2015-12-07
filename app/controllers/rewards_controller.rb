class RewardsController < ApplicationController
  # before_action :set_reward, only: [:show, :edit, :update, :destroy]

  # # GET /schedules
  # # GET /schedules.json
  # def index
  # end

  # # GET /schedules/1
  # # GET /schedules/1.json
  # def show
  # end

  # # GET /schedules/new
  # def new
  # end

  # # GET /schedules/1/edit
  # def edit
  # end

  # # POST /schedules
  # # POST /schedules.json
  # def create
  # end

  # # PATCH/PUT /schedules/1
  # # PATCH/PUT /schedules/1.json
  # def update
  # end

  # # DELETE /schedules/1
  # # DELETE /schedules/1.json
  # def destroy
  # end

  def get_rewards_by_customers_telephone
    ctm = Customer.find_or_initialize_by(telefone: params[:telefone])
    prof = current_professional
    tSafiras = Reward.find_or_initialize_by(professional: prof, customer: ctm).total_safiras
    
    render json: { tSafiras: tSafiras, cId: ctm.id }
  end

  def assign_rewards_to_customer
    @photo = Photo.find_by_id(params[:photo_id])
    Photo.increment_counter(:share_count, @photo)

    if cliente_divulgando_por_recompensa?
      @ci = @photo.customer_invitation
      @rewards = @ci.award_rewards(@photo.id)
    end

    respond_to do |format|
      format.js { render :assign_rewards_to_customer }
    end
  end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_reward
  #     @reward = Reward.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def reward_params
  #     data = params.require(:reward).permit()
  #   end

  def cliente_divulgando_por_recompensa?
    params[:recompensar].present?
  end

end
