require "test_helper"

feature "Calendario" do
  def setup
    super
    skip("Evitando JS") if ENV["js"] == "false"

    @profAline = Professional.create!(nome: 'Aline',
                                    password: '123456',
                                    password_confirmation: '123456',
                                    email: 'cristiano.souza.mendonca@gmail.com',
                                    confirmed_at: '2015-01-01 00:00:00')
  end

  scenario "profissional pode acessar seu calendário", js: true do
    visit root_path
    fill_in 'professional[email]', with: @profAline.email
    fill_in 'professional[password]', with: '123456'
    click_button "Entrar"
    page.must_have_content I18n.t('date.month_names')[Date.today.month]
  end
end