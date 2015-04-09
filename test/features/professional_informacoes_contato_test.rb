require "test_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

feature "Informações de Contato" do
  before do
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'
  end

  scenario "Profissional Testando sem Informações de Contato deve ser redirecionado para edição de IC" do
    @sem_ic = professionals('testando_sem_informacoes_de_contato')
    login_as(@sem_ic, :scope => :professional)
    visit professional_root_path
    assert_equal edit_professional_registration_path, page.current_path, 'Não redirecionado para edição de IC'
    assert page.has_css?("div.alert-success", text: "Seja bem vindo!!! Como primeiro passo para utilizar todos os recursos que fornecemos, cadastre abaixo suas Informações de Contato e visualize o resultado de suas alterações instantaneamente no simulador.")
  end

  scenario "Profissional Testando com Informações de Contato, mas sem serviços, deve ser redirecionado para criação de serviços" do
    @sem_servico = professionals('prof_testando')
    login_as(@sem_servico, :scope => :professional)
    visit professional_root_path
    assert_equal new_service_path, page.current_path
    assert page.has_css?("div.alert-success", text: "Como último passo para utilizar o sistema, cadastre abaixo um dos seus serviços. Isso lhe permitirá utilizar a agenda do Safira Salões - a qual será sua grande amiga daqui pra frente :D")
  end
end