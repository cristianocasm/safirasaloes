require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @profAline = professionals('aline')
    sign_in :professional, @profAline
    ApplicationController.any_instance.stubs(:resource_name).returns(:professional)
  end

  test "should post get_last_two_months_scheduled_customers" do
    xhr :post, :get_last_two_months_scheduled_customers
    assert_response :success
  end

  test "should render layout application.html.erb" do
    get :new
    assert_template :new
    assert_template layout: 'layouts/professional'
  end

  test "deve gravar recompensa de divulgação" do
    @schedule = { customer_id: customers(:sonia), datahora_inicio: DateTime.now.to_default_s, datahora_fim: 1.hour.from_now.to_default_s, service_id: @profAline.services.first.id }

    xhr :post, :create, schedule: @schedule
    assert assigns(:schedule).recompensa_divulgacao, @profAline.services.first.recompensa_divulgacao
  end

  test "deve atualizar recompensa de divulgação" do
    schedule = @profAline.schedules.first
    schedule.service_id = @profAline.services.second.id
    xhr :patch, :update, id: schedule, schedule: schedule.attributes
    assert assigns(:schedule).recompensa_divulgacao, schedule.service.recompensa_divulgacao
    assert_not_equal assigns(:schedule).recompensa_divulgacao, @profAline.services.first.recompensa_divulgacao
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:schedules)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create schedule" do
  #   assert_difference('Schedule.count') do
  #     post :create, schedule: { customer_id: @schedule.customer_id, hora: @schedule.hora, professional_id: @schedule.professional_id, service_id: @schedule.service_id }
  #   end

  #   assert_redirected_to schedule_path(assigns(:schedule))
  # end

  # test "should show schedule" do
  #   get :show, id: @schedule
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @schedule
  #   assert_response :success
  # end

  # test "should update schedule" do
  #   patch :update, id: @schedule, schedule: { customer_id: @schedule.customer_id, hora: @schedule.hora, professional_id: @schedule.professional_id, service_id: @schedule.service_id }
  #   assert_redirected_to schedule_path(assigns(:schedule))
  # end

  # test "should destroy schedule" do
  #   assert_difference('Schedule.count', -1) do
  #     delete :destroy, id: @schedule
  #   end

  #   assert_redirected_to schedules_path
  # end
end
