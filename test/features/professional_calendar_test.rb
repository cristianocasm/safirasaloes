require "test_helper"

feature "Calendario" do
  def setup
    super
    skip("Evitando JS") if ENV["js"] == "false"
  end

  scenario "profissional pode acessar seu calendário", js: true do
    visit root_path
    fill_in 'professional[email]', with: @profAline.email
    fill_in 'professional[password]', with: '123456'
    click_button "Entrar"
    page.must_have_content I18n.t('date.month_names')[Date.today.month]
  end
end