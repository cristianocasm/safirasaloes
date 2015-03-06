require "test_helper"

feature "Alertas" do
  before do
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'
  end

  feature "Profissional em Período de Teste" do
    before do
      @pTestando = professionals(:prof_testando)
      login_as(@pTestando, :scope => :professional)
      visit root_path
    end

    scenario "Deve ver mensagem de alerta" do
      assert_equal page.current_path, root_path
      assert page.has_css?("div.alert-warning", text: "Seu período de testes finaliza no dia #{@pTestando.data_expiracao_status.strftime('%d/%m/%Y')}. Clique aqui e torne-se Premium.")
      assert page.has_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_css?("#main_content"), "Não consegue visualizar conteúdo principal"
    end

    scenario "deve ser capaz de acessar serviços" do
      click_link "Serviços"
      assert_equal page.current_path, services_path
    end

    feature "Expirado" do
      before do
        @pTestando.update_attribute(:data_expiracao_status, 1.day.ago)
        login_as(@pTestando, :scope => :professional)
        visit root_path
      end

      scenario "deve ver mensagem de alerta" do
        assert_equal page.current_path, root_path
        assert page.has_css?("div.alert-warning", text: "Seu período de testes acabou. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades. Atenção! Seu cadastro será suspenso no dia #{@pTestando.data_expiracao_status.strftime('%d/%m/%Y')} e você não terá mais acesso ao sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades")
        assert page.has_css?("#sidebar"), "Não consegue visualizar sidebar"
        assert page.has_css?("#main_content"), "Não consegue visualizar conteúdo principal"
      end

    end
  end

  feature "Profissional em Período de Bloqueio" do
    before do
      @pBloqueado = professionals(:prof_bloqueado)
      login_as(@pBloqueado, :scope => :professional)
      visit root_path
    end
  
    scenario "deve ver mensagem de alerta" do
      assert_equal page.current_path, root_path
      assert page.has_css?("div.alert-warning", text: "Seu período de testes acabou. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades. Atenção! Seu cadastro será suspenso no dia #{@pBloqueado.data_expiracao_status.strftime('%d/%m/%Y')} e você não terá mais acesso ao sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades")
      assert page.has_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_css?("#main_content"), "Não consegue visualizar conteúdo principal"
    end

    scenario "não pode criar schedule", js: true do
    find('div.fc-content-skeleton .fc-today').click
    assert page.has_no_css?("#myModal", visible: true), "Modal de cadastro sendo exibido"
    end

    scenario "não pode acessar serviços" do
      click_link "Serviços"
      assert_equal page. current_path, root_path
    end

    feature "Expirado" do
      before do
        @pBloqueado.update_attribute(:data_expiracao_status, 1.day.ago)
        login_as(@pBloqueado, :scope => :professional)
        visit root_path
      end

    scenario "deve ser incapaz de visualizar qualquer funcionalidade do sistema" do
      assert_equal page.current_path, root_path
      assert page.has_no_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_no_css?("#main_content"), "Consegue visualizar conteúdo principal"
    end

    scenario "deve visualizar mensagem de alerta" do
      assert page.has_css?("div.alert-warning", text: "Sua conta está suspensa e você não pode utilizar os recursos deste sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades.")
    end

    end
  end

  feature "Profissional Suspenso" do
    before do
      @pSuspenso = professionals(:prof_suspenso)
      login_as(@pSuspenso, :scope => :professional)
      visit root_path
    end

    scenario "deve ser incapaz de visualizar qualquer funcionalidade do sistema" do
      assert_equal page.current_path, root_path
      assert page.has_no_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_no_css?("#main_content"), "Consegue visualizar conteúdo principal"
    end

    scenario "deve visualizar mensagem de alerta" do
      assert page.has_css?("div.alert-warning", text: "Sua conta está suspensa e você não pode utilizar os recursos deste sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades.")
    end
  end

  feature "Profissional Assinante" do
    before do
      @pAssinante = professionals(:prof_assinante)
      login_as(@pAssinante, :scope => :professional)
      visit root_path
    end

    scenario "não deve ver mensagens de alerta" do
      assert_equal page.current_path, root_path
      assert page.has_no_css?("div.alert-warning")
      assert page.has_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_css?("#main_content"), "Não consegue visualizar conteúdo principal"
    end

    scenario "deve ser capaz de acessar serviços" do
      click_link "Serviços"
      assert_equal page.current_path, services_path
    end
  end
end