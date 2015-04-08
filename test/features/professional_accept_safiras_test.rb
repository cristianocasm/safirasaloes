require "test_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

def open_schedule_form
  oneHourAhead = 1.hours.from_now
  twoHoursAhead = 2.hours.from_now

  visit professional_root_path
  find('.fc-agendaWeek-button').click
  execute_script("
    $('#calendar').fullCalendar(
      'select',
      '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
      '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
    )
  ")
end

feature "Troca de Safiras - Criação de Horário" do
  before do
    # Cristiano possui 25 Safiras com João - o que o 
    # habilita a trocar pelos serviços:
    #
    # ** cabelo_joao
    # ** barba_joao
    #
    # e não o habilita a trocar por:
    # ** bigode_joao
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'
    
    @profJoao = professionals(:joao)
    login_as(@profJoao, :scope => :professional)

    open_schedule_form

    @ct = customers(:cristiano)
    fill_in('schedule_telefone', with: @ct.telefone[0..7])
    page.execute_script %Q{ $('#schedule_telefone').trigger("focus") }
    wait_for_ajax
    page.find('div.tt-suggestion').click
  end

  scenario "checkbox 'Pagar com Safiras' é exibido para Serviços que possuem preço inferior às Safiras do Cliente", js: true do
    within "div.professional_service" do
      find("option[value='#{ services(:cabelo_joao).id }']").click
      assert page.has_css?('#pagamento_com_safiras'), 'checkbox não sendo exibido para serviço com preço igual à quantidade de Safiras do cliente'
      
      find("option[value='#{ services(:bigode_joao).id }']").click
      assert page.has_no_css?('#pagamento_com_safiras'), 'checkbox sendo exibido para serviço com preço superior à quantidade de Safiras do cliente'

      find("option[value='#{ services(:barba_joao).id }']").click
      assert page.has_css?('#pagamento_com_safiras'), 'checkbox não sendo exibido para serviço com preço inferior à quantidade de Safiras do cliente'
    end
  end

  scenario "não deve resgatar safiras", js: true do
    Schedule.expects(:deal_with_safiras_acceptance).never
    rw = Reward.
          where(
            "professional_id = ? AND customer_id = ?",
            @profJoao.id,
            @ct.id
          ).first

    assert_no_difference(Proc.new { rw.total_safiras }) do
      within "div.professional_service" do
        find("option[value='#{ services(:cabelo_joao).id }']").click
      end

      click_button 'Marcar Horário'

      wait_for_ajax
    end

    sc = @profJoao.schedules.last
    assert_equal 0, sc.safiras_resgatadas
  end
  
  scenario "deve resgatar safiras", js: true do
    rw = Reward.
          where(
            "professional_id = ? AND customer_id = ?",
            @profJoao.id,
            @ct.id
          ).first

    total_safiras = rw.total_safiras

    within "div.professional_service" do
      find("option[value='#{ services(:cabelo_joao).id }']").click
      find("#schedule_pago_com_safiras").set(true)
    end

    click_button 'Marcar Horário'

    wait_for_ajax

    sc = @profJoao.schedules.last

    assert_equal (sc.service.preco*2).to_i, sc.safiras_resgatadas
    assert_equal (total_safiras - (sc.service.preco*2)).to_i, Reward.where("professional_id = ? AND customer_id = ?",@profJoao.id,@ct.id).first.total_safiras
  end

end

def edit_schedule_by_service(sc_service)
  @sc = schedules(sc_service)
  page.execute_script %Q{ $(".fc-content").trigger('mouseenter') }
  within("div#calendar") { find("a[href='#{edit_schedule_path(@sc.id)}']").click }
  wait_for_ajax
end

feature "Troca de Safiras - Edição de Horário" do
  before do
    # Cristiano possui 25 Safiras com João - o que o 
    # habilita a trocar pelos serviços:
    #
    # ** cabelo_joao
    # ** barba_joao
    #
    # e não o habilita a trocar por:
    # ** bigode_joao
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'
    page.driver.browser.manage.window.maximize
    @profJoao = professionals(:joao)
    login_as(@profJoao, :scope => :professional)
    visit professional_root_path
  end

  scenario "checkbox 'Pagar com Safiras' é exibido marcado para Serviços pago com Safiras", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_cabelo)

    within "div.professional_service" do
      assert page.has_css?('input#schedule_pago_com_safiras:checked'), 'checkbox não marcado ou não visível'
    end
  end

  scenario "checkbox 'Pagar com Safiras' é exibido desmarcado para Serviços não pagos com Safiras, mas para cliente com Safiras suficiente", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_barba)

    within "div.professional_service" do
      assert page.has_css?('input#schedule_pago_com_safiras:not(:checked)'), 'checkbox marcado ou não visível'
    end
  end

  scenario "checkbox 'Pagar com Safiras' não é exibido para Serviços não pagos com Safiras e cliente sem Safiras suficiente", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_bigode)

    within "div.professional_service" do
      assert page.has_no_css?('span#pagamento_com_safiras'), 'checkbox sendo exibido'
    end
  end

  scenario "não deve alterar 'safiras_resgatadas' e 'rewards.total_safiras' quando 'pago_com_safiras' permanece true", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_cabelo)

    assert_no_difference(Proc.new { Reward.where("professional_id = ? AND customer_id = ?",@sc.professional_id,@sc.customer_id).first.total_safiras }) do
      fill_in 'schedule_nome', with: 'Cristiano Alencar'
      click_button 'Marcar Horário'
      wait_for_ajax
    end

    assert_equal Schedule.find(@sc.id).safiras_resgatadas, @sc.safiras_resgatadas
    assert_equal Schedule.find(@sc.id).nome, 'Cristiano Alencar'
  end

  scenario "não deve alterar 'safiras_resgatadas' e 'rewards.total_safiras' quando 'pago_com_safiras' permanece false", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_bigode)

    assert_no_difference(Proc.new { Reward.where("professional_id = ? AND customer_id = ?",@sc.professional_id,@sc.customer_id).first.total_safiras }) do
      fill_in 'schedule_nome', with: 'Cristiano Alencar'
      click_button 'Marcar Horário'
      wait_for_ajax
    end

    assert_equal Schedule.find(@sc.id).safiras_resgatadas, @sc.safiras_resgatadas
    assert_equal Schedule.find(@sc.id).nome, 'Cristiano Alencar'
  end

  scenario "deve alterar 'safiras_resgatadas' e 'rewards.total_safiras' quando 'pago_com_safiras' é alterado de true para false", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_cabelo)

    assert_difference(Proc.new { Reward.where("professional_id = ? AND customer_id = ?",@sc.professional_id,@sc.customer_id).first.total_safiras }, @sc.safiras_resgatadas) do
      fill_in 'schedule_nome', with: 'Cristiano Alencar'
      find("#schedule_pago_com_safiras").set(false)
      click_button 'Marcar Horário'
      wait_for_ajax
    end

    assert_equal 0, Schedule.find(@sc.id).safiras_resgatadas
    assert_equal 'Cristiano Alencar', Schedule.find(@sc.id).nome
    assert_equal false, Schedule.find(@sc.id).pago_com_safiras
  end

  scenario "deve alterar 'safiras_resgatadas' e 'rewards.total_safiras' quando 'pago_com_safiras' é alterado de false para true", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_barba)

    assert_difference(Proc.new { Reward.where("professional_id = ? AND customer_id = ?",@sc.professional_id,@sc.customer_id).first.total_safiras }, -(@sc.service.preco * 2)) do
      fill_in 'schedule_nome', with: 'Cristiano Alencar'
      find("#schedule_pago_com_safiras").set(true)
      click_button 'Marcar Horário'
      wait_for_ajax
    end

    assert_equal (@sc.service.preco * 2), Schedule.find(@sc.id).safiras_resgatadas
    assert_equal 'Cristiano Alencar', Schedule.find(@sc.id).nome
    assert_equal true, Schedule.find(@sc.id).pago_com_safiras
  end

  scenario "mudança de cliente com Safiras para cliente sem Safiras esconde checkbox", js: true do
    edit_schedule_by_service(:sch_cristiano_com_joao_service_barba)
    assert page.has_css?('span#pagamento_com_safiras'), 'checkbox não sendo exibido'
    
    ctm = customers(:abilio)
    fill_in('schedule_email', with: ctm.email)
    page.execute_script %Q{ $('#schedule_email').trigger("focus") }
    wait_for_ajax
    page.find('div.tt-suggestion').click
    wait_for_ajax
    assert page.has_no_css?('span#pagamento_com_safiras'), 'checkbox sendo exibido'
  end

  scenario "mudança de cliente com Safiras para cliente com Safiras mantem exibição de checkbox", js: true do
    # verificar se checkbox se mantem preenchido - deve estar despreenchido


    # edit_schedule_by_service(:sch_cristiano_com_joao_service_barba)
    # assert page.has_css?('span#pagamento_com_safiras'), 'checkbox não sendo exibido'
    
    # ctm = customers(:abilio)
    # fill_in('schedule_email', with: ctm.email)
    # page.execute_script %Q{ $('#schedule_email').trigger("focus") }
    # wait_for_ajax
    # assert page.has_no_css?('span#pagamento_com_safiras'), 'checkbox sendo exibido'
  end

  scenario "mudança de cliente sem Safiras para cliente sem Safiras não exibe checkbox", js: true do
    edit_schedule_by_service(:sch_abilio_com_joao_service_bigode)
    assert page.has_no_css?('span#pagamento_com_safiras'), 'checkbox sendo exibido'
    
    ctm = customers(:cristiano)
    fill_in('schedule_email', with: ctm.email)
    page.execute_script %Q{ $('#schedule_email').trigger("focus") }
    wait_for_ajax
    page.find('div.tt-suggestion').click
    wait_for_ajax
    assert page.has_no_css?('span#pagamento_com_safiras'), 'checkbox sendo exibido'
  end

  scenario "mudança de cliente sem Safiras para cliente com Safiras exibe checkbox", js: true do
    edit_schedule_by_service(:sch_abilio_com_joao_service_barba)
    assert page.has_no_css?('span#pagamento_com_safiras'), 'checkbox sendo exibido'
    
    ctm = customers(:cristiano)
    fill_in('schedule_email', with: ctm.email)
    page.execute_script %Q{ $('#schedule_email').trigger("focus") }
    wait_for_ajax
    page.find('div.tt-suggestion').click
    wait_for_ajax
    assert page.has_css?('span#pagamento_com_safiras:not(:checked)'), 'checkbox não sendo exibido'
  end
end


# Serviço definido -> Mudança de cliente
# - Safiras suficiente
# - Safiras insuficientes

# Cliente definido -> Mudança de serviço
# - Safiras suficiente
# - Safiras insuficientes