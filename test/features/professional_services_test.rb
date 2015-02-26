require "test_helper"

feature "Services" do

  before do
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @aline = professionals(:aline)
    @joao  = professionals(:joao)

    profAline = professionals('aline')
    login_as(profAline, :scope => :professional)
    visit root_path
    click_link_or_button "servicos"
  end

  scenario "exibe lista de serviços de aline" do
    visit root_path
    click_link "Serviços"
    
    @aline.services.each do |svc|
      assert page.has_content?(svc.nome), 'Serviços de Aline não estão sendo exibidos'
    end
  end

  scenario "não exibe lista de serviços de joão" do
    @joao.services.each do |svc|
      assert page.has_no_content?(svc.nome), 'Serviços de João sendo exibidos para Aline'
    end
  end

  scenario "pode consultar serviço" do
    srv = @aline.services_ordered.first
    click_link "Consultar", href: "/services/#{srv.id}"
    assert page.has_content?("Consultar Serviço")
    assert page.has_content?(srv.nome)
    assert page.has_content?(srv.preco)
  end

  scenario "edição carrega valores dos campos corretamente serviço" do
    srv = @aline.services_ordered.first
    click_link "Editar", href: "/services/#{srv.id}/edit"
    assert page.has_content?("Editar Serviço")
    assert page.has_xpath?("//input[@id='service_nome' and @value='#{srv.nome}']")
    assert page.has_xpath?("//input[@id='service_preco' and @value='#{srv.preco}']")
  end

  scenario "pode editar serviço" do
    srv = @aline.services_ordered.first
    click_link "Editar", href: edit_service_path(srv)
    fill_in "service_nome", with: 'Serviço Teste'
    fill_in "service_preco", with: 10000
    click_button "Cadastrar"
    visit services_path
    assert page.has_content?("Serviço Teste")
    assert page.has_content?("10000")
  end

  scenario "pode deletar serviço", js: true do
    srv = @aline.services.first
    page.accept_alert 'Deletar registro?' do
      page.accept_alert 'Deletar registro?' do
        click_link "Excluir", href: service_path(srv)
      end
    end
    assert page.has_no_content?(srv.nome), "Serviço ainda exibido"
  end

  scenario "pode criar serviço" do
    click_link "Cadastrar Serviço"
    fill_in "service_nome", with: "Serviço Teste 1"
    fill_in "service_preco", with: 100001
    click_button "Cadastrar"
    assert page.has_content?("Serviço Teste"), 'Nome do serviço não exibido'
    assert page.has_content?("100001"), 'Preço do serviço não exibido'
  end
end