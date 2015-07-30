require "test_helper"

feature "Services" do
  include ActionView::Helpers::NumberHelper

  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @aline = professionals(:aline)
    @joao  = professionals(:joao)

    profAline = professionals('aline')
    login_as(profAline, :scope => :professional)
    visit professional_root_path
    click_link_or_button "servicos"
  end

  feature "Deleção de Serviço" do
    feature "Com Preço Fixo" do
      scenario "não pode deletar serviço que possua horário marcado no futuro", js: true do
        srv = schedules(:sch_sonia).price.service
        page.accept_alert 'Deletar registro?' do
          click_link "Excluir", href: service_path(srv)
        end
        assert page.has_css?("div.alert-danger", text: "Serviço não foi excluído devido à existência de horários marcados para ele."), "Serviço excluído"
        assert page.has_no_css?("div.alert-success", text: "Serviço excluído com sucesso."), "Serviço excluído"
      end

      scenario "não pode deletar serviço que possua horário marcado no passado", js: true do
        srv = schedules(:sch_cristiano_com_aline2).price.service
        page.accept_alert 'Deletar registro?' do
          click_link "Excluir", href: service_path(srv)
        end
        assert page.has_css?("div.alert-danger", text: "Serviço não foi excluído devido à existência de horários marcados para ele."), "Serviço excluído"
        assert page.has_no_css?("div.alert-success", text: "Serviço excluído com sucesso."), "Serviço excluído"
      end
      
      scenario "pode deletar serviço que não possua horário marcado - preço também é deletado", js: true do
        srv = services(:servico_sem_horario_aline)
        srvCount = Service.count
        priceCount = Price.count

        page.accept_alert 'Deletar registro?' do
          click_link "Excluir", href: service_path(srv)
        end
        assert page.has_css?("div.alert-success", text: "Serviço excluído com sucesso.")
        assert page.has_no_content?(srv.nome), "Serviço ainda exibido"
        assert_equal srvCount-1, Service.count
        assert_equal priceCount-1, Price.count
      end

    end

    feature "Preço Variável" do
      scenario "preço não pode ser deletado se houver horário marcado no futuro" do
        skip("A fazer")
      end
      
      scenario "preço não pode ser deletado se houver horário marcado no passado" do
        skip("A fazer")
      end
      
      scenario "preço não pode ser deletado se houver apenas 2 preços para o serviço" do
        skip("A fazer - não esquecer de criar mensagem que informe sobre como proceder")
      end

    end
  end

  feature "Edição de Serviço" do
    feature "Com Preço Fixo" do

      scenario "não pode atualizar com nome em branco", js: true do
        srv = @aline.services_ordered.first
        click_link "Editar", href: edit_service_path(srv)
        fill_in "service_nome", with: ''
        assert page.has_css?("button:disabled", text: 'Informe o Nome do Serviço para Prosseguir')
      end

      scenario "edição carrega valores dos campos corretamente serviço", js: true do
        srv = @aline.services_ordered.first
        click_link "Editar", href: edit_service_path(srv.id)
        assert page.has_content?("Editar Serviço"), 'Não possui texto "Editar Serviço"'
        assert page.has_xpath?("//input[@id='service_nome' and @value='#{srv.nome}']"), "Não carregou o nome do serviço"
        click_button "Próximo Passo >"
        assert page.has_css?("input[id$='_preco'][value='#{'%.2f' % srv.prices.first.preco}']"), "Não carregou o preço do serviço"
        assert page.has_css?("input[id$='_recompensa_divulgacao'][value='#{srv.prices.first.recompensa_divulgacao}']"), "Não carregou a recompensa de divulgação"
      end

      scenario "pode editar serviço", js: true do
        srv = @aline.services_ordered.first
        click_link "Editar", href: edit_service_path(srv)
        fill_in "service_nome", with: 'Serviço Teste 1'
        click_button "Próximo Passo >"
        find(:css, "input[id$='_preco']").set(100)
        click_button "Salvar Serviço e Preço"
        assert page.has_css?("div.alert-success", text: 'Serviço atualizado com sucesso.'), "Não exibindo 'Serviço atualizado com sucesso.'"
        visit services_path
        assert page.has_content?("Serviço Teste 1"), 'Não exibindo nome do serviço.'
        assert page.has_content?(number_to_currency(1)), 'Não exibindo preço do serviço.'
      end

      scenario "ao ser redefinido como preço variável deleta preco fixo", js: true do
        srv = services(:servico_sem_horario_aline2)
        click_link "Editar", href: edit_service_path(srv)
        choose('Preços Variados')
        click_button "Próximo Passo >"

        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"

        descs = page.all("input[id$='_descricao']")
        prices = page.all("input[id$='_preco']")
        rewards = page.all("input[id$='recompensa_divulgacao']")

        descs[0].set('Descrição de Teste 1')
        prices[0].set(100)
        rewards[0].set(10)

        descs[1].set('Descrição de Teste 2')
        prices[1].set(100)
        rewards[1].set(10)
        # Assegura-se que preços antigos foram deletados e que novo
        # foi criado
        assert_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end
      end

      scenario "ao ser redefinido como preço variável não deleta preco fixo se houver horário marcado", js: true do
        srv = schedules(:sch_cristiano_com_aline).price.service
        click_link "Editar", href: edit_service_path(srv)
        choose('Preços Variados')
        click_button "Próximo Passo >"

        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"

        descs = page.all("input[id$='_descricao']")
        prices = page.all("input[id$='_preco']")
        rewards = page.all("input[id$='recompensa_divulgacao']")

        descs[0].set('Descrição de Teste 1')
        prices[0].set(100)
        rewards[0].set(10)

        descs[1].set('Descrição de Teste 2')
        prices[1].set(100)
        rewards[1].set(10)
        # Assegura-se que preços antigos foram deletados e que novo
        # foi criado
        assert_no_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end

        assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.com_horario_marcado', tipo_preco: 'Variável').gsub('^','')), "Erro relacionado à existência de horários para preços não exibido"
      end

    end

    feature "Com Preço Variável" do
      
      scenario "ao ser redefinido como preço fixo deleta demais preços", js: true do
        srv = services(:mechas_aline)
        click_link "Editar", href: edit_service_path(srv)
        choose('Preço Único')
        click_button "Próximo Passo >"
        find(:css, "input[id$='_preco']").set(10)
        find(:css, "input[id$='_recompensa_divulgacao']").set(1)

        count = srv.prices.length

        # Assegura-se que preços antigos foram deletados e que novo
        # foi criado
        assert_difference('Price.count', 1 - count) do
          assert_no_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end
      end

      scenario "não permite deleção de preços se total de preços do serviço ficar menor que 2", js: true do
        srv = services(:mechas_aline)
        click_link "Editar", href: edit_service_path(srv)
        click_button "Próximo Passo >"
        links = page.all('a.remove_fields')

        links[0].click
        links[1].click

        assert_no_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end

        assert page.has_css?("div.alert-danger ul li", text: I18n.t('servico.com_preco_variavel.deve_ter_pelo_menos_2_precos').gsub('^','')), "Erro relacionado à necessidade de pelo menos 2 preços não exibido"
      end

      scenario "carrega informações cadastradas", js: true do
        srv = services(:mechas_aline)
        click_link "Editar", href: edit_service_path(srv)
        
        assert find(:css, "input[id='service_nome']").value == srv.nome, 'Não carregando nome do serviço'
        
        click_button "Próximo Passo >"
        
        srv.prices.each do |pr|
          assert find(:css, "input[id$='_descricao'][value='#{pr.descricao}']"), 'Não carregando descrição do preço'
          assert find(:css, "input[id$='_preco'][value='#{'%.2f' % pr.preco}']"), 'Não carregando preço do preço'
          assert find(:css, "input[id$='_recompensa_divulgacao'][value='#{pr.recompensa_divulgacao}']"), 'Não carregando recompensa do preço'
        end

        assert_no_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end

        assert page.has_css?("div.alert-danger ul li", text: I18n.t('servico.com_preco_variavel.deve_ter_pelo_menos_2_precos').gsub('^','')), "Erro relacionado à necessidade de pelo menos 2 preços não exibido"
      end
    
    end
  end

  feature "Listagem de Serviços" do
    feature "Com Preço Fixo" do
      
      scenario "exibe lista de serviços de aline" do
        visit professional_root_path
        click_link "Serviços"
        
        @aline.services.each do |svc|
          assert page.has_content?(svc.nome), 'Serviços de Aline não estão sendo exibidos'
        end
      end

      scenario "não exibe lista de serviços de joão", js: true do
        within("#table") do
          @joao.services.each do |svc|
            assert page.has_no_content?(svc.nome), 'Serviços de João sendo exibidos para Aline'
          end
        end
      end

    end
  end

  feature "Consulta de Serviços" do
    feature "Com Preço Fixo" do
      scenario "pode consultar serviço" do
        srv = @aline.services_ordered.second
        price = srv.prices.first
        click_link "Consultar", href: service_path(srv.id)
        assert page.has_content?("Consultar Serviço")
        assert page.has_content?(srv.nome)
        assert page.has_content?(number_to_currency(price.preco))
        assert page.has_content?(price.recompensa_divulgacao)
      end
    end
  end

  feature "Criação de Serviço" do
    feature "Com Preço Fixo" do
      scenario "deve ser capaz de criar serviço com nome igual a outro profissional", js: true do
        jSrv = @joao.services.first.nome
        click_link "Cadastrar Serviço"
        fill_in 'service_nome', with: jSrv
        click_button "Próximo Passo >"
        find(:css, "input[id$='_preco']").set(100)
        click_button "Salvar Serviço e Preço"
        assert page.has_css?("div.alert-success", text: "Serviço criado com sucesso.")
        assert page.has_content?(jSrv), 'Nome do serviço não exibido'
        assert page.has_content?(number_to_currency(1)), 'Preço do serviço não exibido'
      end

      scenario "não deve ser capaz de criar serviços com nomes iguais", js: true do
        click_link "Cadastrar Serviço"
        fill_in 'service_nome', with: @aline.services.first.nome.downcase
        click_button "Próximo Passo >"
        find(:css, "input[id$='_preco']").set(100)
        click_button "Salvar Serviço e Preço"
        assert page.has_css?("div.alert-danger ul li", text: "Nome já está em uso"), "Erro 'Nome já está em uso' não exibido"
      end

      scenario "pode criar serviço", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste 2"
        click_button "Próximo Passo >"
        find(:css, "input[id$='_preco']").set(100001)
        click_button "Salvar Serviço e Preço"
        assert page.has_css?("div.alert-success", text: "Serviço criado com sucesso.")
        assert page.has_content?("Serviço Teste 2"), 'Nome do serviço não exibido'
        assert page.has_content?(number_to_currency(1000.01)), 'Preço do serviço não exibido'
      end

      scenario "deve ser capaz de definir recompensas", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste 3"
        click_button "Próximo Passo >"
        find(:css, "input[id$='_preco']").set(10000)
        find(:css, "input[id$='_recompensa_divulgacao']").set(20)
        click_button "Salvar Serviço e Preço"
        assert page.has_content?("Consultar Serviço")
        assert page.has_content?("Serviço Teste 3"), 'Nome do serviço não exibido'
        assert page.has_content?(number_to_currency(100.00)), 'Preço do serviço não exibido'
        assert page.has_content?(20), 'Recompensa do serviço não exibida'
      end

      scenario "deve ser capaz de saber o que são as Safiras", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste"
        click_button "Próximo Passo >"
        all('.dica')[0].click
        assert page.has_selector?('h3', text: "Defina a Recompensa por Divulgação", :visible => true)
      end

      scenario "não deve ver campo 'descrição'", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste"
        click_button "Próximo Passo >"
        assert page.has_no_selector?("input[id$='_descricao']"), 'Campo "descrição" sendo exibido para preço fixo'
      end
    end

    feature "Com Preço Variável" do
      scenario "deve ver campo 'descrição'", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste"
        choose('Preços Variados')
        click_button "Próximo Passo >"
        click_link "Definir Novo Preço"
        assert page.has_selector?("input[id$='_descricao']"), 'Campo "descrição" não sendo exibido para preço variável'
      end

      scenario "valida dados informados", js: true do
        click_link "Cadastrar Serviço"
        fill_in 'service_nome', with: 'Teste'
        choose('Preços Variados')
        click_button "Próximo Passo >"
        # Criando dois preços
        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"

        descs = page.all("input[id$='_descricao']")
        prices = page.all("input[id$='_preco']")
        rewards = page.all("input[id$='recompensa_divulgacao']")

        descs[0].set('')
        prices[0].set(100)
        rewards[0].set(10)

        descs[1].set('Testando')
        prices[1].set(10)
        rewards[1].set('1a')

        descs[2].set('Testando')
        prices[2].set(0)
        rewards[2].set(1)

        assert_no_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end
        
        assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.sem_descricao').gsub('^','')), "Erro relacionado a descrição não sendo exibido"
        assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.descricao_repetida').gsub('^','')), "Erro relacionado a unicidade de descrição não sendo exibido"
        assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.recompensa_deve_ser_positivo_ou_zero').gsub('^','')), "Erro relacionado a recompensa não sendo exibido"
        assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.deve_ser_positivo').gsub('^','')), "Erro relacionado ao preço não sendo exibido"
      end

      scenario "deve ser capaz de cadastrar n preços", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste"
        choose('Preços Variados')
        click_button "Próximo Passo >"
        assert page.has_no_selector?("input[id$='_descricao']"), 'Campo "descrição" sendo exibido para preço variável antes de clicar em adicionar novo preço'
        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"
        assert page.has_selector?("input[id$='_descricao']", count: 5), 'Não foram criados campos suficientes para definição de recompensas'
        assert page.has_selector?("input[id$='_preco']", count: 5), 'Não foram criados campos suficientes para definição de recompensas'
        assert page.has_selector?("input[id$='_recompensa_divulgacao']", count: 5), 'Não foram criados campos suficientes para definição de recompensas'
      end

      scenario "com menos de 2 preços não cria", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste"
        choose('Preços Variados')
        click_button "Próximo Passo >"
        click_link "Definir Novo Preço"
        fill_in 'Descrição', with: 'Descrição 1'
        fill_in 'Preço', with: 10
        fill_in 'Recompensa Por Divulgação (Safiras)', with: 1
        
        assert_no_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end

        assert page.has_css?("div.alert-danger ul li", text: I18n.t('servico.com_preco_variavel.deve_ter_pelo_menos_2_precos'))
      end

      scenario "com 2 preços, salva", js: true do
        click_link "Cadastrar Serviço"
        fill_in "service_nome", with: "Serviço Teste"
        choose('Preços Variados')
        click_button "Próximo Passo >"
        # Criando dois preços
        click_link "Definir Novo Preço"
        click_link "Definir Novo Preço"

        descs = page.all("input[id$='_descricao']")
        prices = page.all("input[id$='_preco']")
        rewards = page.all("input[id$='recompensa_divulgacao']")

        descs[0].set('Descrição 1')
        prices[0].set(100)
        rewards[0].set(10)

        descs[1].set('Descrição 2')
        prices[1].set(200)
        rewards[1].set(20)
        
        assert_difference('Price.count', 2) do
          assert_difference('Service.count') do
            click_button "Salvar Serviço e Preço"
          end
        end

        assert page.has_css?("div.alert-success", text: "Serviço criado com sucesso.")
      end

    end
  end

end