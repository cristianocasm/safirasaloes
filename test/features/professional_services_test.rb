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

        assert_difference('Service.count', -1) do
          assert_difference('Price.count', -1) do
            page.accept_alert 'Deletar registro?' do
              click_link "Excluir", href: service_path(srv)
            end    
            assert page.has_css?("div.alert-success", text: "Serviço excluído com sucesso.")
            assert page.has_no_content?(srv.nome), "Serviço ainda exibido"
          end
        end
        
      end

    end
  end

  feature "Edição de Serviço" do
    feature "Com Preço Fixo" do

      before do
        @srv = @aline.services.where(preco_fixo: true).first
        click_link "Editar", href: edit_service_path(@srv.id)
      end

      scenario "inicializa calculadoras corretamente", js: true, focus: true do
        assert page.has_content?("equivale a R$ #{'%.2f' % (@srv.prices.first.recompensa_divulgacao.to_f/2)}")
      end
      
      scenario "não deve ver campo 'descrição' nem link para deleção, mas deve ver campo de preço e recompensa" do
        within("form.service_form") do
          assert page.has_no_selector?("input[id$='_descricao']"), 'Campo "descrição" sendo exibido'
          assert page.has_no_link?("Excluir preço"), 'Link para deleção sendo exibido'
          assert page.has_selector?("input[id$='_preco']"), 'Campo "preço" não sendo exibido'
          assert page.has_selector?("input[id$='_recompensa_divulgacao']"), 'Campo "recompensa" não sendo exibido'
        end
      end

      scenario "edição carrega valores dos campos corretamente serviço", js: true do
        assert page.has_xpath?("//input[@id='service_nome' and @value='#{@srv.nome}']"), "Não carregou o nome do serviço"
        assert page.has_css?("input[id$='_preco'][value='#{'%.2f' % @srv.prices.first.preco}']"), "Não carregou o preço do serviço"
        assert page.has_css?("input[id$='_recompensa_divulgacao'][value='#{@srv.prices.first.recompensa_divulgacao}']"), "Não carregou a recompensa de divulgação"
      end

      scenario "deve ver 2 campos 'descrição' e 2 links de deleção quando novo preço for adicionado", js: true do
        within("form.service_form") do
          click_link "Adicionar Novo Preço"
          assert page.has_selector?("input[id$='_descricao']", count: 2), "Campo 'recompensa' não sendo exibido 2 vezes"
          assert page.has_link?("Excluir preço", count: 2), 'Link para deleção não sendo exibido 2 vezes'
        end
      end

      scenario "pode editar serviço" do
        srv = @aline.services_ordered.first
        click_link "Editar", href: edit_service_path(srv)
        fill_in "service_nome", with: 'Serviço Teste 1'
        find(:css, "input[id$='_preco']").set(100)
        click_button "Salvar"
        assert page.has_css?("div.alert-success", text: 'Serviço atualizado com sucesso.'), "Não exibindo 'Serviço atualizado com sucesso.'"
        visit services_path
        assert page.has_content?("Serviço Teste 1"), 'Não exibindo nome do serviço.'
        assert page.has_content?(number_to_currency(1)), 'Não exibindo preço do serviço.'
      end

      scenario "ao ser redefinido como preço variável deleta preco fixo", js: true do
        visit services_path
        srv = services(:servico_sem_horario_aline2)
        click_link "Editar", href: edit_service_path(srv)
        click_link "Adicionar Novo Preço"

        descs = page.all("input[id$='_descricao']")
        prices = page.all("input[id$='_preco']")
        rewards = page.all("input[id$='recompensa_divulgacao']")

        descs[0].set('Descrição de Teste 3')
        prices[0].set(100)
        rewards[0].set(10)

        descs[1].set('Descrição de Teste 4')
        prices[1].set(100)
        rewards[1].set(10)
        # Assegura-se que preços antigos foram deletados e que novo
        # foi criado
        assert_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar"
          end
        end
      end

      scenario "com horário marcado não exibe link para deleção", js: true do
        visit services_path
        srv = schedules(:sch_cristiano_com_aline).price.service
        click_link "Editar", href: edit_service_path(srv)
        click_link "Adicionar Novo Preço"
        page.has_link?(I18n.t('price.com_horario_marcado.nao_pode_ser_excluido'), count: 1)
        page.has_link?("Excluir preço", count: 1)
      end

    end

    feature "Com Preço Variável" do

      before do
        @srv = services(:mechas_aline)
        click_link "Editar", href: edit_service_path(@srv)
      end

      scenario "carrega informações cadastradas", js: true do
        assert find(:css, "input[id='service_nome']").value == @srv.nome, 'Não carregando nome do serviço'
        
        @srv.prices.each do |pr|
          assert find(:css, "input[id$='_descricao'][value='#{pr.descricao}']"), 'Não carregando descrição do preço'
          assert find(:css, "input[id$='_preco'][value='#{'%.2f' % pr.preco}']"), 'Não carregando preço do preço'
          assert find(:css, "input[id$='_recompensa_divulgacao'][value='#{pr.recompensa_divulgacao}']"), 'Não carregando recompensa do preço'
        end

        assert_no_difference('Price.count') do
          assert_no_difference('Service.count') do
            click_button "Salvar"
          end
        end

        assert page.has_css?("div.alert-danger ul li", text: I18n.t('servico.com_preco_variavel.deve_ter_pelo_menos_2_precos').gsub('^','')), "Erro relacionado à necessidade de pelo menos 2 preços não exibido"
      end

      scenario "inicializa calculadoras corretamente", js: true, focus: true do
        @srv.prices.each do |pr|
          assert page.has_content?("equivale a R$ #{'%.2f' % (pr.recompensa_divulgacao.to_f/2)}")
        end
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
        srv = @aline.services.where(preco_fixo: true).first
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
    before do
      click_link "Cadastrar Serviço"
    end
    
    feature "Com Preço Fixo" do
      scenario "deve ser capaz de criar serviço com nome igual a outro profissional", js: true do
        jSrv = @joao.services.first.nome
        fill_in 'service_nome', with: jSrv
        find(:css, "input[id$='_preco']").set(100)
        click_button "Salvar"
        assert page.has_css?("div.alert-success", text: "Serviço criado com sucesso.")
        assert page.has_content?(jSrv), 'Nome do serviço não exibido'
        assert page.has_content?(number_to_currency(1)), 'Preço do serviço não exibido'
      end

      scenario "não deve ser capaz de criar serviços com nomes iguais", js: true do
        fill_in 'service_nome', with: @aline.services.first.nome.downcase
        find(:css, "input[id$='_preco']").set(100)
        click_button "Salvar"
        assert page.has_css?("div.alert-danger ul li", text: "Nome já está em uso"), "Erro 'Nome já está em uso' não exibido"
      end

      scenario "pode criar serviço", js: true do
        fill_in "service_nome", with: "Serviço Teste 2"
        find(:css, "input[id$='_preco']").set(100001)
        click_button "Salvar"
        assert page.has_css?("div.alert-success", text: "Serviço criado com sucesso.")
        assert page.has_content?("Serviço Teste 2"), 'Nome do serviço não exibido'
        assert page.has_content?(number_to_currency(1000.01)), 'Preço do serviço não exibido'
      end

      scenario "deve ser capaz de definir recompensas", js: true do
        fill_in "service_nome", with: "Serviço Teste 3"
        find(:css, "input[id$='_preco']").set(10000)
        find(:css, "input[id$='_recompensa_divulgacao']").set(20)
        click_button "Salvar"
        assert page.has_content?("Consultar Serviço")
        assert page.has_content?("Serviço Teste 3"), 'Nome do serviço não exibido'
        assert page.has_content?(number_to_currency(100.00)), 'Preço do serviço não exibido'
        assert page.has_content?(20), 'Recompensa do serviço não exibida'
      end

      scenario "deve ser capaz de saber o que são as Safiras", js: true do
        fill_in "service_nome", with: "Serviço Teste"
        all('.dica')[1].click
        assert page.has_selector?('h3', text: "Defina a Recompensa por Divulgação", :visible => true)
      end

      scenario "não deve ver campo 'descrição' nem link para deleção, mas deve ver campo de preço e recompensa" do
        within("form.service_form") do
          assert page.has_no_selector?("input[id$='_descricao']"), 'Campo "descrição" sendo exibido'
          assert page.has_no_link?("Excluir preço"), 'Link para deleção sendo exibido'
          assert page.has_selector?("input[id$='_preco']"), 'Campo "preço" não sendo exibido'
          assert page.has_selector?("input[id$='_recompensa_divulgacao']"), 'Campo "recompensa" não sendo exibido'
        end
      end

      scenario "não deve ver campo descrição, nem link para deleção, mas deve ver campo de preço e recompensa se depois de ter preços\
      variados volta para preço fixo", js: true do
        within("form.service_form") do
          click_link "Adicionar Novo Preço"
          first(:link, "Excluir preço").click
          assert page.has_no_selector?("input[id$='_descricao']"), 'Campo "descrição" sendo exibido'
          assert page.has_no_link?("Excluir preço"), 'Link para deleção sendo exibido'
          assert page.has_selector?("input[id$='_preco']"), 'Campo "preço" não sendo exibido'
          assert page.has_selector?("input[id$='_recompensa_divulgacao']"), 'Campo "recompensa" não sendo exibido'
        end
      end

      scenario "com 1 preço - após ter tido 2 preços - salva como preço fixo", js: true do
        click_link "Adicionar Novo Preço"
        first(:link, "Excluir preço").click
        fill_in "service_nome", with: "Serviço Teste1"
        fill_in 'Preço', with: 10
        fill_in 'Recompensa Por Divulgação', with: 1

        click_button "Salvar"
        
        srv = Service.last
        assert_equal service_path(srv), page.current_path
        assert srv.preco_fixo?, "Salvando como preço variável serviço com único preço"
      end

      scenario "com 1 preço salva como preço fixo" do
        fill_in "service_nome", with: "Serviço Teste2"
        fill_in 'Preço', with: 10
        fill_in 'Recompensa Por Divulgação', with: 1

        assert_difference('Price.count') do
          assert_difference('Service.count') do
            click_button "Salvar"
          end
        end

        srv = Service.last
        
        assert_equal service_path(srv), page.current_path
        assert srv.preco_fixo?, "Salvando como preço variável serviço com único preço"
      end

      scenario "inicializa calculadoras corretamente", js: true do
        recompensa = 17
        fill_in 'Recompensa Por Divulgação', with: recompensa

        assert page.has_content?("equivale a R$ #{recompensa/2}")
      end

    end





    scenario "com 2 preços salva como preço variável", js: true do
      fill_in "service_nome", with: "Serviço Teste"
      click_link "Adicionar Novo Preço"

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
          click_button "Salvar"
        end
      end

      srv = Service.last
      
      assert_equal service_path(srv), page.current_path
      assert_not srv.preco_fixo?, "Salvando como preço variável serviço com único preço"
    end

    scenario "com 2 preços e erro no cadastro não esconde campo de descrição e link para deleção", js: true do
      click_link "Adicionar Novo Preço"
      click_button "Salvar"
      within("form.service_form") do
        assert page.has_selector?("input[id$='_descricao']", count: 2), 'Campo descrição não sendo exibido 2 vezes'
        assert page.has_link?("Excluir preço", count: 2), 'Link para deleção não sendo exibido 2 vezes'
      end
    end

    scenario "deve ver 2 campos 'descrição' e 2 links de deleção quando novo preço for adicionado", js: true do
      click_link "Adicionar Novo Preço"
      within("form.service_form") do
        assert page.has_selector?("input[id$='_descricao']", count: 2)
        assert page.has_link?("Excluir preço", count: 2), 'Link para deleção não sendo exibido'
      end
    end

    scenario "valida dados informados", js: true do
      fill_in 'service_nome', with: 'Teste'
      click_link "Adicionar Novo Preço"
      click_link "Adicionar Novo Preço"

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
          click_button "Salvar"
        end
      end
      
      assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.sem_descricao').gsub('^','')), "Erro relacionado a descrição não sendo exibido"
      assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.descricao_repetida').gsub('^','')), "Erro relacionado a unicidade de descrição não sendo exibido"
      assert page.has_css?("div.alert-danger ul li", text: I18n.t('price.deve_ser_positivo').gsub('^','')), "Erro relacionado ao preço não sendo exibido"
    end

  end

end