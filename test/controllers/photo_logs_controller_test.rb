require 'test_helper'

class PhotoLogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "deve ser redirecionado para 'Meus Serviços' caso não possa enviar fotos" do
    @customer = customers(:fernanda)
    sign_in :customer, @customer

    get :new
    assert_redirected_to customer_root_path
    assert_equal "Você não foi atendido por um profissional nas últimas 12 horas e, por isso, ainda não pode enviar fotos.", flash["error"]
  end

  test "deve ser capaz de acessar 'Enviar Fotos' caso tenha sido atendido" do
    @customer = customers(:cristiano)
    sign_in :customer, @customer

    get :new
    assert_response :success
  end

#   test "should get index" do
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:photo_logs)
#   end

#   test "should get new" do
#     get :new
#     assert_response :success
#   end

#   test "should create photo_log" do
#     assert_difference('PhotoLog.count') do
#       post :create, photo_log: { customer_id: @photo_log.customer_id, professional_id: @photo_log.professional_id, safiras: @photo_log.safiras, schedule_id: @photo_log.schedule_id, service_id: @photo_log.service_id }
#     end

#     assert_redirected_to photo_log_path(assigns(:photo_log))
#   end

#   test "should show photo_log" do
#     get :show, id: @photo_log
#     assert_response :success
#   end

#   test "should get edit" do
#     get :edit, id: @photo_log
#     assert_response :success
#   end

#   test "should update photo_log" do
#     patch :update, id: @photo_log, photo_log: { customer_id: @photo_log.customer_id, professional_id: @photo_log.professional_id, safiras: @photo_log.safiras, schedule_id: @photo_log.schedule_id, service_id: @photo_log.service_id }
#     assert_redirected_to photo_log_path(assigns(:photo_log))
#   end

#   test "should destroy photo_log" do
#     assert_difference('PhotoLog.count', -1) do
#       delete :destroy, id: @photo_log
#     end

#     assert_redirected_to photo_logs_path
#   end
end
