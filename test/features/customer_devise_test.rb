require "test_helper"

feature "Customer com Devise" do
  before do
    @customer = customers(:cristiano)
    visit new_customer_session_path
  end

  scenario "pode logar-se no sistema" do
    fill_in 'customer_email', with: @customer.email
    fill_in 'customer_password', with: 'password'
    click_button 'Entrar'
    assert_equal customer_root_path, page.current_path
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