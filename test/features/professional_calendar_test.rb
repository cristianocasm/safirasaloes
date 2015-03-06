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
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @profAline = professionals('aline')
    login_as(@profAline, :scope => :professional)
  end

  scenario "profissional pode acessar seu calendário", js: true do
    skip("Evitando JS") if ENV["js"] == "false"
    visit root_path
    assert page.has_table?('calendar_table'), 'Agenda não está sendo exibida'
  end

  scenario "profissional pode criar horário", js: true do
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
    find('.fc-agendaWeek-button').click
    fill_in "schedule_customer_id", with: customers(:cristiano).id
    select @profAline.services.first.nome, from: :schedule_service_id
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_no_css?("#myModal", visible: true), "Modal com formulário aparecendo"
    assert page.has_css?("div[data-full='#{oneHourAhead.strftime('%H:00')} - #{twoHoursAhead.strftime('%H:00')}'].fc-time"), 'Não é possível visualizar horário marcado'
  end

  scenario "profissional não pode criar horário com início no passado", js: true do
    oneHourAhead = 5.hours.ago
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
    find('.fc-agendaWeek-button').click
    fill_in "schedule_customer_id", with: customers(:cristiano).id
    select @profAline.services.first.nome, from: :schedule_service_id
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_content?("Datahora inicio deve estar no futuro"), "Modal de formulário não exibe msg de erro"
  end

  scenario "profissional não pode criar horário com início após o fim", js: true do
    oneHourAhead = 5.hours.from_now
    twoHoursAhead = 6.hours.from_now

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
    fill_in "schedule_customer_id", with: customers(:cristiano).id
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
    fill_in "schedule_customer_id", with: customers(:cristiano).id
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
    fill_in "schedule_customer_id", with: customers(:cristiano).id
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
    fill_in "schedule_customer_id", with: customers(:cristiano).id
    click_button 'Marcar Horário'

    wait_for_ajax

    assert page.has_no_css?("#myModalError", visible: true), "Modal de erro aparecendo"
    assert page.has_css?("#myModal", visible: true), "Modal com formulário não aparecendo"
    assert page.has_content?("Service não pode ficar em branco"), "Modal de formulário não exibe msg de erro"
  end
end