require "test_helper"

feature "Services" do
  include ActionView::Helpers::NumberHelper

  before do
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @aline = professionals(:aline)
    @joao  = professionals(:joao)

    profAline = professionals('aline')
    login_as(profAline, :scope => :professional)
    visit root_path
    click_link_or_button "servicos"
  end

  scenario "não pode atualizar com nome em branco" do
    srv = @aline.services_ordered.first
    click_link "Editar", href: edit_service_path(srv)
    fill_in "service_nome", with: ''
    fill_in "service_preco", with: 10000
    click_button "Cadastrar"
    assert page.has_css?("div.alert-danger ul li", text: "Nome não pode ficar em branco")
  end

  scenario "deve ser capaz de criar serviço com nome igual a outro profissional" do
    jSrv = @joao.services.first.nome
    click_link "Cadastrar Serviço"
    fill_in 'service_nome', with: jSrv
    fill_in 'service_preco', with: 100
    click_button "Cadastrar"
    assert page.has_css?("div.alert-success", text: "Serviço criado com sucesso.")
    assert page.has_content?(jSrv), 'Nome do serviço não exibido'
    assert page.has_content?(number_to_currency(100)), 'Preço do serviço não exibido'
  end

  scenario "não deve ser capaz de criar serviços com nomes iguais", js: true do
    click_link "Cadastrar Serviço"
    fill_in 'service_nome', with: @aline.services.first.nome.downcase
    fill_in 'service_preco', with: 100
    click_button "Cadastrar"
    assert page.has_css?("div.alert-danger ul li", text: "Nome já está em uso"), "Erro 'Nome já está em uso' não exibido"
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
    assert page.has_content?(number_to_currency(srv.preco))
    assert page.has_content?(srv.recompensa_divulgacao)
  end

  scenario "edição carrega valores dos campos corretamente serviço" do
    srv = @aline.services_ordered.first
    click_link "Editar", href: "/services/#{srv.id}/edit"
    assert page.has_content?("Editar Serviço"), 'Não possui texto "Editar Serviço"'
    assert page.has_xpath?("//input[@id='service_nome' and @value='#{srv.nome}']"), "Não carregou o nome do serviço"
    assert page.has_xpath?("//input[@id='service_preco' and @value='#{'%.2f' % srv.preco}']"), "Não carregou o preço do serviço"
  end

  scenario "pode editar serviço" do
    srv = @aline.services_ordered.first
    click_link "Editar", href: edit_service_path(srv)
    fill_in "service_nome", with: 'Serviço Teste'
    fill_in "service_preco", with: 10000
    click_button "Cadastrar"
    assert page.has_css?("div.alert-success", text: 'Serviço atualizado com sucesso.')
    visit services_path
    assert page.has_content?("Serviço Teste")
    assert page.has_content?(number_to_currency(10000))
  end

  scenario "pode deletar serviço", js: true do
    srv = @aline.services.first
    page.accept_alert 'Deletar registro?' do
      click_link "Excluir", href: service_path(srv)
    end
    assert page.has_css?("div.alert-success", text: "Serviço excluído com sucesso.")
    assert page.has_no_content?(srv.nome), "Serviço ainda exibido"
  end

  scenario "pode criar serviço" do
    click_link "Cadastrar Serviço"
    fill_in "service_nome", with: "Serviço Teste 1"
    fill_in "service_preco", with: 100001
    click_button "Cadastrar"
    assert page.has_css?("div.alert-success", text: "Serviço criado com sucesso.")
    assert page.has_content?("Serviço Teste"), 'Nome do serviço não exibido'
    assert page.has_content?(number_to_currency(100001)), 'Preço do serviço não exibido'
  end

  scenario "deve ser capaz de definir recompensas" do
    click_link "Cadastrar Serviço"
    fill_in "service_nome", with: "Serviço Teste 2"
    fill_in "service_preco", with: 100.00
    fill_in "service_recompensa_divulgacao", with: 20
    click_button "Cadastrar"
    assert page.has_content?("Consultar Serviço")
    assert page.has_content?("Serviço Teste 2"), 'Nome do serviço não exibido'
    assert page.has_content?(number_to_currency(100.00)), 'Preço do serviço não exibido'
    assert page.has_content?(20), 'Recompensa do serviço não exibida'
  end


  scenario "deve ser capaz de saber o que são as Safiras", js: true do
    click_link "Cadastrar Serviço"
    all('.dica')[0].hover
    assert page.has_selector?('h3', title="Defina a Recompensa por Divulgação", :visible => true)
    # all('.dica')[1].hover
    # assert page.has_selector?('h3', title="Defina a Recompensa por Fidelidade", :visible => true)
  end

  scenario "apresenta mensagens de erro corretas quando nome e preco não são informados" do
    click_link "Cadastrar Serviço"
    click_button "Cadastrar"
    assert page.has_css?("div.alert-danger ul li", text: "Nome não pode ficar em branco")
    assert page.has_css?("div.alert-danger ul li", text: "Preco não pode ficar em branco")
  end

end