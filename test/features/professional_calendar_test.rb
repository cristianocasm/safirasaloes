require "test_helper"

feature "Calendario" do
  before do
    skip("Evitando JS") if ENV["js"] == "false"

    profAline = professionals('Aline')
    login_as(profAline, :scope => :professional)
  end

  scenario "profissional pode acessar seu calendário", js: true do
    visit root_path
    byebug
    page.must_have_content I18n.t('date.month_names')[Date.today.month]
  end
end