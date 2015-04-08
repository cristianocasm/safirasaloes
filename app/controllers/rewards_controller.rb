class RewardsController < ApplicationController
  before_action :set_reward, only: [:show, :edit, :update, :destroy]

  # GET /schedules
  # GET /schedules.json
  def index
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
  end

  def get_customer_rewards
    tSafiras = current_professional.rewards.try(:find_by_customer_id, params[:customer_id]).try(:total_safiras) || 0
    render json: { total_safiras: tSafiras }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reward
      @reward = Reward.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reward_params
      data = params.require(:reward).permit()
    end

end
