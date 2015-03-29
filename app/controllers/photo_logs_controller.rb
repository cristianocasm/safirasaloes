class PhotoLogsController < ApplicationController
  before_action :set_photo_log, only: [:show, :edit, :update, :destroy]

  # GET /photo_logs
  # GET /photo_logs.json
  def index
    @photo_logs = PhotoLog.all
  end

  # GET /photo_logs/1
  # GET /photo_logs/1.json
  def show
  end

  # GET /photo_logs/new
  def new
    @photo_log = PhotoLog.new
  end

  # GET /photo_logs/1/edit
  def edit
  end

  # POST /photo_logs
  # POST /photo_logs.json
  def create
    @photo_log = PhotoLog.new(photo_log_params)

    respond_to do |format|
      if @photo_log.save
        format.html { redirect_to @photo_log, notice: 'Photo log was successfully created.' }
        format.json { render :show, status: :created, location: @photo_log }
      else
        format.html { render :new }
        format.json { render json: @photo_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photo_logs/1
  # PATCH/PUT /photo_logs/1.json
  def update
    respond_to do |format|
      if @photo_log.update(photo_log_params)
        format.html { redirect_to @photo_log, notice: 'Photo log was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo_log }
      else
        format.html { render :edit }
        format.json { render json: @photo_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_logs/1
  # DELETE /photo_logs/1.json
  def destroy
    @photo_log.destroy
    respond_to do |format|
      format.html { redirect_to photo_logs_url, notice: 'Photo log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_log
      @photo_log = PhotoLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_log_params
      params.require(:photo_log).permit(:customer_id, :professional_id, :schedule_id, :service_id, :safiras)
    end
end
