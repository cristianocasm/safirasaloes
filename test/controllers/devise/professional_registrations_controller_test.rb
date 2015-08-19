require 'test_helper'

class Devise::ProfessionalRegistrationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:professional]
  end

  context "Telas Devise" do
    should ":new deve renderizar layout login" do
      get :new
      assert_response :success
      assert_template :new
      assert_template layout: 'layouts/login'
    end

    should ":create deve renderizar layout login" do
      put :create, professional: { email: 'testtest@test.com', password: 'testing', password_confirmation: 'testing' }
      assert_redirected_to new_professional_session_path
    end

    should ":edit deve renderizar layout professional" do
      sign_in professionals(:aline)
      get :edit
      assert_response :success
      assert_template :edit
      assert_template layout: 'layouts/professional/professional'
    end

    should ":update deve renderizar layout professional" do
      @aline = professionals(:aline)
      sign_in @aline

      patch :update, id: @aline, professional: { nome: 'Test' }
      assert_redirected_to professional_root_path
    end
  end

  context "Editando Informações de Contato" do
    setup do
      @prof = professionals(:testando_sem_informacoes_de_contato)
      sign_in :professional, @prof
    end

    should "salva passo 'tela_cadastro_contato_acessada' como realizado" do
      get :edit
      assert Professional.find(@prof.id).taken_step.tela_cadastro_contato_acessada, "Passo 'tela_cadastro_contato_acessada' não sendo salvo"
    end

    should "salva passo 'contato_cadastrado' como realizado" do
      patch :update, id: @aline, professional: { nome: 'Test', telefone: '(33) 3333-3333' }
      assert Professional.find(@prof.id).taken_step.contato_cadastrado, "Passo 'contato_cadastrado' não sendo salvo"
    end

    should "não salva passo 'contato_cadastrado' como realizado se contato não foi atualizado" do
      patch :update, id: @aline
      assert_not Professional.find(@prof.id).taken_step.contato_cadastrado, "Passo 'contato_cadastrado' sendo salvo"
    end
  end

end