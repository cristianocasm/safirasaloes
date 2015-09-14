require "test_helper"

feature "Professional com Devise" do
  before do
    @professional = professionals(:aline)
    visit new_professional_session_path
  end

  scenario "pode logar-se no sistema" do
    fill_in 'professional_email', with: @professional.email
    fill_in 'professional_password', with: 'password'
    click_button 'Entrar'
    assert_equal professional_root_path, page.current_path
  end

  scenario "não cadastrado não pode logar-se no sistema" do
  end

  scenario "pode cadastrar-se no sistema" do
  end

  scenario "cadastrado não pode cadastrar-se novamente" do
  end

  scenario "pode resgatar senha" do
  end

  scenario "não cadastrado não pode resgatar senha" do
  end

  scenario "pode solicitar reenvio de instruções de confirmação" do
  end

  scenario "sem cadastro prévio não pode solicitar reenvio de instruções de confirmação" do
  end

  scenario "pode confirmar cadastro" do
  end

  scenario "pode acessar devise features de profissional" do
  end

end

feature "Alteração de Senha" do

  before do
    @professional = professionals(:nao_confirmado)
    visit edit_professional_password_path(reset_password_token: 'test_token123')
  end

  scenario "profissional sem conta confirmada, sem nome e sem whatsapp/telefone pode alterar senha", js: true do
    Devise::TokenGenerator.any_instance.stubs(:key_for).returns('reset_password_token')
    fill_in 'Nova senha', with: '123456'
    fill_in 'Confirme a nova senha', with: '123456'
    click_button 'Alterar Senha'
    assert_equal edit_professional_registration_path, page.current_path
  end

end