require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @aline = professionals(:aline)
    sign_in :professional, @aline
    @service = services(:unha_mao_aline)
    @serviceJoao = services(:bigode_joao)
  end

  # Início testes padrão
  test "deve renderizar layout application.html.erb" do
    get :new
    assert_template :new
    assert_template layout: 'layouts/professional/professional'
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
    patch :update, id: @service, service: { nome: @service.nome, preco: @service.prices.first.preco }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, id: @service
    end

    assert_redirected_to services_path
  end

  test "salva passo 'tela_cadastro_servico_acessada' como realizado" do
    get :new
    assert Professional.find(@aline.id).taken_step.tela_cadastro_servico_acessada, "Passo 'tela_cadastro_servico_acessada' não sendo salvo"
  end

  test "salva passo 'servico_cadastrado' como realizado" do
    post :create, service: { nome: "Serviço Teste", preco: 100 }
    assert Professional.find(@aline.id).taken_step.servico_cadastrado, "Passo 'servico_cadastrado' não sendo salvo"
  end

  test "não salva passo 'servico_cadastrado' como realizado se houver erro" do
    post :create, service: { nome: "" }
    assert_not Professional.find(@aline.id).taken_step.servico_cadastrado, "Passo 'servico_cadastrado' sendo salvo"
  end

  # test "exibe mensagem personalizada para primeiro serviço cadastrado" do
  #   prof = professionals :prof_testando
  #   sign_in :professional, prof
  #   post :create, service: { nome: "Serviço Teste", preco: 100 }
  #   assert_equal flash[:success], "<p>Serviço criado com sucesso.</p><p><b>PARABÉNS!</b> A partir de agora você pode utilizar a agenda
  #       do SafiraSalões (clicando em <b>'MINHA AGENDA'</b>) para que:</p>
  #       <ol>
  #         <li>Seu cliente seja <b>convidado a divulgar</b> o serviço prestado por você sempre que ele for agendado;</li>
  #         <li>Seu cliente seja <b>recompensado</b> sempre que ele realizar a divulgação do serviço prestado por você;</li>
  #         <li>Seu cliente seja <b>alertado sobre o hórário agendado</b>;</li>
  #         <li>Seu cliente seja alertado (3 horas antes do horário marcado) sobre a <b>aproximação do horário agendado</b>;</li>
  #       </ol>
  #       <p>Ou seja, utilize a agenda do SafiraSalões para (1) <b>aumentar a divulgação boca-a-boca dos seus serviços</b>, (2) <b>fidelizar</b> e (3) <b>melhorar o
  #       relacionamento com o seu cliente</b> e (4) <b>diminuir prejuízos com ausências</b>.</p>
  #       <p>Para agendar seus clientes clique em <b>'MINHA AGENDA'</b>. Você poderá cadastrar outros de seus serviços a qualquer momento clicando em <b>'MEUS SERVIÇOS'</b>.</p>"

  # end
end
