require "test_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

feature "Ordens de Troca" do
  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @profAline = professionals('aline')
    login_as(@profAline, :scope => :professional)
  end

  scenario "indicando 0 ordens de troca" do
    visit professional_root_path
    assert_equal "0", find("#ordens_trocas").text
  end

  feature "Faye" do
    scenario "Profissional recebe alerta de nova ordem de troca", js: true do
      skip("Implementando...")
      visit professional_root_path
      click_link "Criar ordem"
      wait_for_ajax
      assert_equal "1", find("#ordens_trocas").text

      # Muito lenta
      # visit professional_root_path
      # assert_difference('find("#ordens_trocas").text.to_i') do
      #   click_link "Criar ordem"
      #   wait_for_ajax
      # end
    end
  end

end