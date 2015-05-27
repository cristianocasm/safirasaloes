class DashboardController < ApplicationController
  def index
  end

  def taken_steps
    start = 30.days.ago.to_date
    _end = Date.today.to_date

    takenSteps = Professional.taken_steps_report(start, _end)
    
    render json: takenSteps, status: :ok
  end
end