require "test_helper"

feature "Services" do
  before do
    profAline = professionals('aline')
    login_as(profAline, :scope => :professional)

    @aline = professionals(:aline)
    @joao  = professionals(:joao)
  end

  scenario "exibe lista de serviços de aline" do
    visit root_path
    click_link "Serviços"
    
    @aline.services.each do |svc|
      assert page.has_table?(svc.nome), 'Serviços de Aline não estão sendo exibidos'
    end
  end

  scenario "não exibe lista de serviços de joão" do
    visit root_path
    click_link "Serviços"
    
    @joao.services.each do |svc|
      assert page.has_no_content?(svc.nome), 'Serviços de João sendo exibidos para Aline'
    end
  end
end