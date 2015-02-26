require "test_helper"

feature "Calendario" do
  before do
    skip("Evitando JS") if metadata['js'] && ENV['js'] == 'false'

    profAline = professionals('aline')
    login_as(profAline, :scope => :professional)
  end

  scenario "profissional pode acessar seu calendário", js: true do
    skip("Evitando JS") if ENV["js"] == "false"
    visit root_path
    assert page.has_table?('calendar_table'), 'Agenda não está sendo exibida'
  end
end