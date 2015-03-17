require "test_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

feature "Calendario" do
  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @profAline = professionals('aline')
    login_as(@profAline, :scope => :professional)
  end

  scenario "profissional pode acessar seu calendário", js: true do
    visit root_path
    assert page.has_table?('calendar_table'), 'Agenda não está sendo exibida'
  end

  scenario "profissional pode criar horário", js: true do
    oneHourAhead = 4.hours.from_now
    twoHoursAhead = 5.hours.from_now
    visit root_path
    find('.fc-agendaWeek-button').click
    execute_script("
      $('#calendar').fullCalendar(
        'select',
        '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
        '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
      )
    ")
    fill_in "nome_cliente", with: customers(:cristiano).nome
    select @profAline.services.first.nome, from: :schedule_service_id
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_no_css?("#myModal", visible: true), "Modal com formulário aparecendo"
    assert page.has_css?("div[data-full='#{oneHourAhead.strftime('%H:00')} - #{twoHoursAhead.strftime('%H:00')}'].fc-time"), 'Não é possível visualizar horário marcado'
  end

  scenario "profissional pode encontrar customer por nome, e-mail e telefone", js: true do
    oneHourAhead = 4.hours.from_now
    twoHoursAhead = 5.hours.from_now
    visit root_path
    find('.fc-agendaWeek-button').click
    execute_script("
      $('#calendar').fullCalendar(
        'select',
        '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
        '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
      )
    ")
    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_no_css?("#schedule_customer_id"), "Campo 'customer_id' não está oculto"
    assert page.has_css?("#nome_cliente"), "Campo 'Nome' não está aparecendo"
    assert page.has_css?("#email_cliente"), "Campo 'Email' não está aparecendo"
    assert page.has_css?("#telefone_cliente"), "Campo 'Telefone' não está aparecendo"
  end

  scenario "profissional não pode criar horário com início no passado", js: true do
    oneHourAhead = 4.hours.ago
    twoHoursAhead = 5.hours.from_now

    visit root_path
    find('.fc-agendaWeek-button').click
    execute_script("
      $('#calendar').fullCalendar(
        'select',
        '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
        '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
      )
    ")
    find('.fc-agendaWeek-button').click
    fill_in "nome_cliente", with: customers(:cristiano).nome
    select @profAline.services.first.nome, from: :schedule_service_id
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_content?("Datahora inicio deve estar no futuro"), "Modal de formulário não exibe msg de erro"
  end

  scenario "profissional não pode criar horário com início após o fim", js: true do
    oneHourAhead = 4.hours.from_now
    twoHoursAhead = 5.hours.from_now

    visit root_path
    find('.fc-agendaWeek-button').click
    execute_script("
      $('#calendar').fullCalendar(
        'select',
        '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }',
        '#{ oneHourAhead.strftime('%Y-%m-%d %H') }'
      )
    ")
    find('.fc-agendaWeek-button').click
    fill_in "nome_cliente", with: customers(:cristiano).nome
    select @profAline.services.first.nome, from: :schedule_service_id
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_content?("Datahora fim deve ser após Datahora inicio"), "Modal de formulário não exibe msg de erro"
  end

  scenario "profissional não pode criar horário com início igual ao fim", js: true do
    oneHourAhead = 5.hours.from_now
    twoHoursAhead = oneHourAhead

    visit root_path
    find('.fc-agendaWeek-button').click
    execute_script("
      $('#calendar').fullCalendar(
        'select',
        '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }',
        '#{ oneHourAhead.strftime('%Y-%m-%d %H') }'
      )
    ")
    fill_in "nome_cliente", with: customers(:cristiano).nome
    select @profAline.services.first.nome, from: :schedule_service_id
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_content?("Datahora fim deve ser após Datahora inicio"), "Modal de formulário não exibe msg de erro"
  end

  scenario "profissional não pode criar horário sem serviço", js: true do
    oneHourAhead = 5.hours.from_now
    twoHoursAhead = 6.hours.from_now

    visit root_path
    find('.fc-agendaWeek-button').click
    execute_script("
      $('#calendar').fullCalendar(
        'select',
        '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
        '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
      )
    ")
    execute_script("
      $('#schedule_service_id').prop( 'disabled', true );
      ")
    fill_in "nome_cliente", with: customers(:cristiano).nome
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_content?("Service não pode ficar em branco"), "Modal de formulário não exibe msg de erro"
  end

  scenario "profissional não pode criar horário sem serviço", js: true do
    oneHourAhead = 5.hours.from_now
    twoHoursAhead = 6.hours.from_now

    visit root_path
    find('.fc-agendaWeek-button').click
    execute_script("
      $('#calendar').fullCalendar(
        'select',
        '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
        '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
      )
    ")
    execute_script("
      $('#schedule_service_id').val(0);
      ")
    fill_in "nome_cliente", with: customers(:cristiano).nome
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_content?("Service não pode ficar em branco"), "Modal de formulário não exibe msg de erro"
  end
end

def open_schedule_form
  oneHourAhead = 1.hours.from_now
  twoHoursAhead = 2.hours.from_now

  visit root_path
  find('.fc-agendaWeek-button').click
  execute_script("
    $('#calendar').fullCalendar(
      'select',
      '#{ oneHourAhead.strftime('%Y-%m-%d %H') }',
      '#{ twoHoursAhead.strftime('%Y-%m-%d %H') }'
    )
  ")
end

def suggestion_appears?(field, ctm, method, limit)
  fill_in(field, with: ctm.send(method)[0..limit])
  page.execute_script %Q{ $('##{field}').trigger("focus") }
  wait_for_ajax
  assert_equal ctm.send(method), page.find('div.tt-suggestion').text
end

feature "Calendar TypeAhead" do
  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @profAline = professionals('aline')
    login_as(@profAline, :scope => :professional)

    @emailLimit = 5
    @telLimit = 7

    open_schedule_form
  end

  # Uma vez que o sistema não deve preencher o buffer com os dados de clientes atendidos há mais de 60 dias,
  # testo se a função 'filter_by_email' é invocada no model, pois isso indica que ocorreu um AJAX já que
  # os dados não foram encontrados no buffer.
  scenario "sistema não carrega no buffer do profissional dados de clientes atendidos há mais de 60 dias", js: true do
    ct = customers(:abilio)

    Customer.expects(:filter_by_telefone).
      with(ct.telefone[0..@telLimit]).
      returns([Customer.new(nome: ct.nome, email: ct.email, telefone: ct.telefone)])  

    suggestion_appears?('telefone_cliente', ct, :telefone, @telLimit)
  end

  scenario "sistema não carrega no buffer do profissional dados de clientes atendidos há mais de 60 dias", js: true do
    ct = customers(:abilio)

    Customer.expects(:filter_by_email).
      with(ct.email[0..@emailLimit]).
      returns([Customer.new(nome: ct.nome, email: ct.email, telefone: ct.telefone)])  

    suggestion_appears?('email_cliente', ct, :email, @emailLimit)
  end

  scenario "(email) sistema não carrega no buffer do profissional dados de clientes atendidos há menos de 7 dias", js: true do
    ct = customers(:bruno)

    Customer.expects(:filter_by_email).
      with(ct.email[0..@emailLimit]).
      returns([Customer.new(nome: ct.nome, email: ct.email, telefone: ct.telefone)])  

    suggestion_appears?('email_cliente', ct, :email, @emailLimit)
  end

  scenario "(telefone) sistema não carrega no buffer do profissional dados de clientes atendidos há menos de 7 dias", js: true do
    ct = customers(:bruno)

    Customer.expects(:filter_by_telefone).
      with(ct.telefone[0..@telLimit]).
      returns([Customer.new(nome: ct.nome, email: ct.email, telefone: ct.telefone)])  

    suggestion_appears?('telefone_cliente', ct, :telefone, @telLimit)
  end

  scenario "sistema carrega no buffer do profissional os dados de clientes atendidos entre [60, 7] dias atrás", js: true do
    ctCs = customers(:cesar)
    Customer.expects(:filter_by_telefone).never
    suggestion_appears?('telefone_cliente', ctCs, :telefone, @telLimit)
  end

  scenario "sistema carrega no buffer do profissional os dados de clientes atendidos entre [60, 7] dias atrás", js: true do
    ctCs = customers(:cesar)
    Customer.expects(:filter_by_email).never
    suggestion_appears?('email_cliente', ctCs, :email, @emailLimit)
  end

  scenario "sistema carrega no buffer do profissional os dados de clientes atendidos entre [60, 7] dias atrás", js: true do
    ctDa = customers(:daniel)
    Customer.expects(:filter_by_email).never
    suggestion_appears?('email_cliente', ctDa, :email, @emailLimit)
  end

  scenario "sistema carrega no buffer do profissional os dados de clientes atendidos entre [60, 7] dias atrás", js: true do
    ctDa = customers(:daniel)
    Customer.expects(:filter_by_telefone).never
    suggestion_appears?('telefone_cliente', ctDa, :telefone, @telLimit)
  end

  scenario "sistema não carrega no buffer do profissional os dados de clientes atendidos entre [60, 7] dias em outros estabelecimentos", js: true do
    ct = customers(:elano)

    Customer.expects(:filter_by_email).
      with(ct.email[0..@emailLimit]).
      returns([Customer.new(nome: ct.nome, email: ct.email, telefone: ct.telefone)])  

    suggestion_appears?('email_cliente', ct, :email, @emailLimit)
  end

  scenario "sistema não carrega no buffer do profissional os dados de clientes atendidos entre [60, 7] dias em outros estabelecimentos", js: true do
    ct = customers(:elano)

    Customer.expects(:filter_by_telefone).
      with(ct.telefone[0..@telLimit]).
      returns([Customer.new(nome: ct.nome, email: ct.email, telefone: ct.telefone)])  

    suggestion_appears?('telefone_cliente', ct, :telefone, @telLimit)
  end

  scenario "escolha de email preenche 'schedule_customer_id', 'telefone_cliente' e 'nome_cliente'", js: true do
    ct = customers(:cesar)
    fill_in('email_cliente', with: ct.email[0..5])
    page.execute_script %Q{ $('#email_cliente').trigger("focus") }
    wait_for_ajax
    page.find('div.tt-suggestion').click
    assert_equal ct.id.to_s, page.find('#schedule_customer_id', visible: false).value, 'schedule_customer_id não foi preenchido'
    assert_equal ct.telefone, page.find('#telefone_cliente').value, 'telefone_cliente não foi preenchido'
    assert_equal ct.nome, page.find('#nome_cliente').value, 'nome_cliente não foi preenchido'
  end
  
  scenario "escolha de telefone preenche 'client_id'", js: true do
    ct = customers(:cesar)
    fill_in('telefone_cliente', with: ct.telefone[0..7])
    page.execute_script %Q{ $('#telefone_cliente').trigger("focus") }
    wait_for_ajax
    page.find('div.tt-suggestion').click
    assert_equal ct.id.to_s, page.find('#schedule_customer_id', visible: false).value, 'schedule_customer_id não foi preenchido'
    assert_equal ct.telefone, page.find('#telefone_cliente').value, 'telefone_cliente não foi preenchido'
    assert_equal ct.nome, page.find('#nome_cliente').value, 'nome_cliente não foi preenchido'
  end

end