require "test_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

feature "Customer com horários marcados" do
  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @customer = customers(:cristiano)
    login_as(@customer, :scope => :customer)
    visit new_photo_log_path
  end

  scenario "pode escolher para qual serviço enviará as fotos", js: true do
    scs = @customer.schedules.where(datahora_inicio: 12.hours.ago..Time.zone.now).map { |sc| "#{sc.professional.nome} pelo serviço #{sc.price.nome}" }

    within("#fileupload") do
      assert page.has_select?('photo_log_schedule_id', options: scs)
    end
  end

  scenario "Pode enviar fotos e ser recompensado", js: true do
    skip('Última assertion deve ter VCR para não dar erro com o Facebook')
    page.driver.browser.manage.window.maximize
    
    # Escolher Fotos
    within("#fileupload") do
      attach_file('photo_log_image', '/home/cristiano/Imagens/Cristiano.jpg', visible: false)
      assert page.has_css?("img.preview"), "Preview não criado"
      assert page.has_css?("td.name", visible: false), "Elemento 'name' não criado"
      assert page.has_css?("td.delete button.btn-danger", visible: false), "Botão 'excluir' não criado"
    end
    click_link "Próximo Passo"

    # Definir Comentários
    assert_equal photo_log_step_path(id: 'comments'), page.current_path
    click_button "Próximo Passo"

    # Inserir dados do profissional
    click_button "Insira por Mim"
    Customer.any_instance.stubs(:gave_fb_permissions?).returns(true)
    click_link "Próximo Passo"

    # Ganhar Recompensa
    click_link "QUERO MINHAS SAFIRAS AGORA!!!"
    assert_equal customer_root_path, page.current_path
  end

  feature "Foto carregada para Cliente sem permissão no FB" do
    before do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      within("#fileupload") do
        attach_file('photo_log_image', '/home/cristiano/Imagens/Cristiano.jpg', visible: false)
      end
    end

    scenario "pode excluir foto carregada", js: true do
      within("#fileupload") do
        click_button("Cancelar")
        assert page.has_no_css?("td.preview"), "Preview não criado"
        assert page.has_no_css?("td.name", visible: false), "Elemento 'name' não criado"
        assert page.has_no_css?("td.size", visible: false), "Elemento 'size' não criado"
        assert page.has_no_css?("textarea[name='photo_log[description]']"), "Campo de descrição não criado"
        assert page.has_no_css?("td.start", visible: false), "Botão 'start' não criado"
        assert page.has_no_css?("td.cancel"), "Botão 'cancelar' não criado"
      end
    end
  end

    # scenario "deve ser capaz de dar permissões", js: true, focus: true do
    #   click_button("Enviar Todas as Fotos")
    #   wait_for_ajax
    #   VCR.use_cassette "facebook/permissão_negada" do
    #     click_link("Entrar com o Facebook")
    #     byebug
    #     Capybara.current_driver = :mechanize
    #     click_button("Cancelar")
    #   end
    # end
end

feature "Foto carregada para Cliente com permissão no FB" do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:facebook, {:uid => '1234'})

    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @customer = customers(:cristiano_com_integracao)
    login_as(@customer, :scope => :customer)
    visit new_photo_log_path

    within("#fileupload") do
      attach_file('photo_log_image', '/home/cristiano/Imagens/Cristiano.jpg', visible: false)
    end
  end

  # scenario "", js: true do
  #   page.driver.browser.manage.window.maximize
  #   Koala::Facebook::API.any_instance.stubs(:put_picture).returns({})
  #   click_button "Enviar Todas as Fotos"
  #   assert page.has_css?("#loadingModal"), "Modal loading não sendo exibido"
  #   wait_for_ajax
  #   assert_equal customer_root_path, page.current_path
  # end
end