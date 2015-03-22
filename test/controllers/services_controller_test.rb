require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @aline = professionals(:aline)
    sign_in :professional, @aline
    ApplicationController.any_instance.stubs(:resource_name).returns(:professional)
    @service = services(:unha_mao_aline)
    @serviceJoao = services(:bigode_joao)
  end

  # Início testes padrão
  test "deve renderizar layout application.html.erb" do
    get :new
    assert_template :new
    assert_template layout: 'layouts/professional'
  end

  test "não pode deletar serviço de outros" do
    delete :destroy, id: @serviceJoao
    assert_redirected_to services_path
    assert_equal flash[:error], 'Serviço não encontrado'
  end

  test "não pode atualizar serviço de outros" do
    patch :update, id: @serviceJoao
    assert_redirected_to services_path
    assert_equal flash[:error], 'Serviço não encontrado'
  end

  test "não pode consultar serviço de outros" do
    get :show, id: @serviceJoao
    assert_redirected_to services_path
    assert_equal flash[:error], 'Serviço não encontrado'
  end

  test "não pode editar serviço de outros" do
    get :edit, id: @serviceJoao
    assert_redirected_to services_path
    assert_equal flash[:error], 'Serviço não encontrado'
  end

  # Fim testes padrão

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, service: { nome: "Serviço Teste", preco: 100 }
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, id: @service
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service
    assert_response :success
  end

  test "should update service" do
    patch :update, id: @service, service: { nome: @service.nome, preco: @service.preco }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, id: @service
    end

    assert_redirected_to services_path
  end
end
