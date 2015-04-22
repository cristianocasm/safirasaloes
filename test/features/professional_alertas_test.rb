require "test_helper"

feature "Alertas" do
  before do
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
  end

  feature "Profissional em Período de Teste" do
    before do
      @pTestando = professionals(:prof_testando_com_contato_e_servicos)
      login_as(@pTestando, :scope => :professional)
      visit professional_root_path
    end

    scenario "Deve ver mensagem de alerta" do
      assert_equal professional_root_path, page.current_path
      assert page.has_css?("div.alert-warning", text: "Seu período de testes finaliza no dia #{@pTestando.data_expiracao_status.strftime('%d/%m/%Y')}.Clique no botão abaixo para tornar-se PREMIUM:")
      assert page.has_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_css?("#main_content"), "Não consegue visualizar conteúdo principal"
    end

    scenario "deve ser capaz de acessar serviços" do
      click_link "Serviços"
      assert_equal services_path, page.current_path
    end
  end

  feature "Profissional em Período de Bloqueio" do
    before do
      @pBloqueado = professionals(:prof_bloqueado)
      login_as(@pBloqueado, :scope => :professional)
      visit professional_root_path
    end
  
    scenario "deve ver mensagem de alerta" do
      assert_equal professional_root_path, page.current_path
      assert page.has_css?("div.alert-warning", text: "SEU PERÍODO DE TESTES ACABOU!Isso significa que você só poderá visualizar os horários marcados em sua agenda - nada mais.Clique no botão abaixo para tornar-se PREMIUM e reabilitar todas as funcionalidades.Atenção! Seu cadastro será suspenso no dia #{@pBloqueado.data_expiracao_status.strftime('%d/%m/%Y')} e você não terá mais acesso ao sistema.")
      assert page.has_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_css?("#main_content"), "Não consegue visualizar conteúdo principal"
    end

    scenario "não pode criar schedule", js: true do
      oneHourAhead = 4.hours.from_now
      twoHoursAhead = 5.hours.from_now
      execute_script("
        $('#calendar').fullCalendar(
          'select',
          '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
          '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
        )
      ")
      assert page.has_no_css?("#myModal", visible: true), "Modal de cadastro sendo exibido"
    end

    scenario "não pode acessar serviços" do
      click_link "Serviços"
      assert_equal page. current_path, professional_root_path
    end

  end

  feature "Profissional Suspenso" do
    before do
      @pSuspenso = professionals(:prof_suspenso)
      login_as(@pSuspenso, :scope => :professional)
      visit professional_root_path
    end

    scenario "deve ser incapaz de visualizar qualquer funcionalidade do sistema" do
      assert_equal professional_root_path, page.current_path
      assert page.has_no_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_no_css?("#main_content"), "Consegue visualizar conteúdo principal"
    end

    scenario "deve visualizar mensagem de alerta" do
      assert page.has_css?("div.alert-warning", text: "Sua conta está SUSPENSA e você não pode mais utilizar os recursos deste sistema.Clique no botão abaixo para tornar-se Premium e REABILITAR TODAS AS FUNCIONALIDADES INSTANTANEAMENTE.")
    end
  end

  feature "Profissional Assinante" do
    before do
      @pAssinante = professionals(:prof_assinante_com_contato_e_servicos)
      login_as(@pAssinante, :scope => :professional)
      visit professional_root_path
    end

    scenario "não deve ver mensagens de alerta" do
      assert_equal professional_root_path, page.current_path
      assert page.has_no_css?("div.alert-warning")
      assert page.has_css?("#sidebar"), "Não consegue visualizar sidebar"
      assert page.has_css?("#main_content"), "Não consegue visualizar conteúdo principal"
    end

    scenario "deve ser capaz de acessar serviços" do
      click_link "Serviços"
      assert_equal services_path, page.current_path
    end
  end
end