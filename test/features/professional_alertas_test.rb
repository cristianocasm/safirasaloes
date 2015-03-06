require "test_helper"

feature "Alertas" do
  before do
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'
  end

  scenario "profissional em período de teste deve ver mensagem de alerta" do
    pTestando = professionals(:prof_testando)
    login_as(pTestando, :scope => :professional)
    visit root_path
    assert_equal page.current_path, root_path
    assert page.has_css?("div.alert-warning", text: "Seu período de testes finaliza no dia #{pTestando.data_expiracao_status.strftime('%d/%m/%Y')}. Clique aqui e torne-se Premium.")
    assert page.has_css?("#sidebar")
    assert page.has_css?("#main_content")

  end

  # Criar outros testes que verificam inacessibilidade às funcionalidades
  scenario "profissional em período de bloqueio deve ver mensagem de alerta" do
    pBloqueado = professionals(:prof_bloqueado)
    login_as(pBloqueado, :scope => :professional)
    visit root_path
    assert_equal page.current_path, root_path
    assert page.has_css?("div.alert-warning", text: "Seu período de testes acabou. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades. Atenção! Seu cadastro será suspenso no dia #{pBloqueado.data_expiracao_status.strftime('%d/%m/%Y')} e você não terá mais acesso ao sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades")
    assert page.has_css?("#sidebar")
    assert page.has_css?("#main_content")
  end

  scenario "profissional suspenso deve ser incapaz de acessar o sistema" do
    pSuspenso = professionals(:prof_suspenso)
    login_as(pSuspenso, :scope => :professional)
    
    visit root_path
    assert_equal page.current_path, root_path
    assert page.has_css?("div.alert-warning", text: "Sua conta está suspensa e você não pode utilizar os recursos deste sistema. Clique aqui para tornar-se Premium e habilitar todas as funcionalidades.")
    assert page.has_no_css?("#sidebar")
    assert page.has_no_css?("#main_content")
  end

  scenario "profissional assinante não deve ver mensagens de alerta" do
    pAssinante = professionals(:prof_assinante)
    login_as(pAssinante, :scope => :professional)
    visit root_path
    assert_equal page.current_path, root_path
    assert page.has_no_css?("div.alert-warning")
  end
end