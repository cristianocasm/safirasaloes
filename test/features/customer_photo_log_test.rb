require "test_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

feature "Customer com horários marcado" do
  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @customer = customers(:cristiano)
    login_as(@customer, :scope => :customer)
    visit new_photo_log_path
  end

  scenario "pode escolher para qual serviço enviará as fotos" do
    scs = @customer.schedules.where(datahora_inicio: 12.hours.ago..Time.zone.now).map { |sc| "#{sc.professional.nome} - #{sc.service.nome}" }

    within("#fileupload") do
      assert page.has_select?('photo_log_schedule_id', options: scs)
    end
  end

  scenario "Pode escolher fotos", js: true do
    within("#fileupload") do
      attach_file('photo_log_image', '/home/cristiano/Imagens/Cristiano.jpg', visible: false)
      assert page.has_css?("td.preview"), "Preview não criado"
      assert page.has_css?("td.name", visible: false), "Elemento 'name' não criado"
      assert page.has_css?("td.size", visible: false), "Elemento 'size' não criado"
      assert page.has_css?("textarea[name='photo_log[description]']"), "Campo de descrição não criado"
      assert page.has_css?("td.start", visible: false), "Botão 'start' não criado"
      assert page.has_css?("td.cancel"), "Botão 'cancelar' não criado"
    end
  end

  scenario "não pode fazer upload de arquivo com extensão diferente das aceitas", js: true do
    within("#fileupload") do
      page.accept_alert "codeschool_22.mp4 não é um arquivo gif, jpeg, png ou tiff" do
        attach_file('photo_log_image', '/home/cristiano/Downloads/codeschool_22.mp4', visible: false)
      end

      assert page.has_no_css?("td.preview"), "Preview criado"
      assert page.has_no_css?("td.name", visible: false), "Elemento 'name' criado"
      assert page.has_no_css?("td.size", visible: false), "Elemento 'size' criado"
      assert page.has_no_css?("textarea[name='photo_log[description]']"), "Campo de descrição criado"
      assert page.has_no_css?("td.start", visible: false), "Botão 'start' criado"
      assert page.has_no_css?("td.cancel"), "Botão 'cancelar' criado"
    end
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

    scenario "visualiza modal enquanto aguarda submissão e é avisado sobre necessidade de dar permissão", js: true do
      click_button "Enviar Todas as Fotos"
      assert page.has_css?("#loadingModal"), "Modal loading não sendo exibido"
      wait_for_ajax
      assert page.has_css?("#fbModal"), "Modal Fb não sendo exibido"
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

  scenario "", js: true, focus: true do
    page.driver.browser.manage.window.maximize
    Koala::Facebook::API.any_instance.stubs(:put_picture).returns({})
    click_button "Enviar Todas as Fotos"
    assert page.has_css?("#loadingModal"), "Modal loading não sendo exibido"
    wait_for_ajax
    byebug
    assert_equal customer_root_path, page.current_path
  end
end