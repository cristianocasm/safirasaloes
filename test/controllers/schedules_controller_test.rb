# require 'test_helper'

# class SchedulesControllerTest < ActionController::TestCase
#   setup do
#     @schedule = schedules(:one)
#   end

#   test "should get index" do
#     skip
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:schedules)
#   end

#   test "should get new" do
#     skip
#     get :new
#     assert_response :success
#   end

#   test "should create schedule" do
#     skip
#     assert_difference('Schedule.count') do
#       post :create, schedule: { customer_id: @schedule.customer_id, hora: @schedule.hora, professional_id: @schedule.professional_id, service_id: @schedule.service_id }
#     end

#     assert_redirected_to schedule_path(assigns(:schedule))
#   end

#   test "should show schedule" do
#     skip
#     get :show, id: @schedule
#     assert_response :success
#   end

#   test "should get edit" do
#     skip
#     get :edit, id: @schedule
#     assert_response :success
#   end

#   test "should update schedule" do
#     skip
#     patch :update, id: @schedule, schedule: { customer_id: @schedule.customer_id, hora: @schedule.hora, professional_id: @schedule.professional_id, service_id: @schedule.service_id }
#     assert_redirected_to schedule_path(assigns(:schedule))
#   end

#   test "should destroy schedule" do
#     skip
#     assert_difference('Schedule.count', -1) do
#       delete :destroy, id: @schedule
#     end

#     assert_redirected_to schedules_path
#   end
# end
