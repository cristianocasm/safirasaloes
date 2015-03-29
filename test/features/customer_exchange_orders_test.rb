require "test_helper"

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

include ActionView::Helpers::NumberHelper

feature "Troca de Safiras" do
  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'

    @customer = customers(:cristiano)
    login_as(@customer, :scope => :customer)

    visit customer_root_path
    click_link 'Trocar Safiras'
  end

  scenario "serviços dos profissionais que já atenderam o cliente são exibidos uma única vez", focus: true do
    @customer.schedules.each do |sc|
      assert_not page.has_css?('h3 strong', text: sc.professional.nome, count: 0), "Não há nome do profissional"
      assert page.has_css?('h3 strong', text: sc.professional.nome, count: 1), "Nome de profissional sendo exibido mais de uma vez"
      sc.professional.services.each do |srv|
        assert_not page.has_css?('h5', text: "Serviço: #{srv.nome}", count: 0), "Não há nome do serviço"
        assert page.has_css?('h5', text: "Serviço: #{srv.nome}", count: 1), "Nome do serviço sendo exibido mais de uma vez"

        assert_not page.has_css?('h5', text: "Preço: #{number_to_currency(srv.preco)}", count: 0 ), "Não há preço do serviço"
        assert page.has_css?('h5', text: "Preço: #{number_to_currency(srv.preco)}", count: 1 ), "Preço do serviço sendo exibido mais de uma vez"

        assert_not page.has_css?('h5', text: "Recompensa: #{srv.recompensa_divulgacao}", count: 0 ), "Não há recompensa do serviço"
        assert page.has_css?('h5', text: "Recompensa: #{srv.recompensa_divulgacao}", count: 1 ), "Recompensa sendo exibida mais de uma vez"
      end
    end
  end

  scenario "serviços para os quais há horário marcado são exibidos em destaque e mostram data e hora" do
    assert page.has_css?('div.service-scheduled', count: @customer.schedules.in_the_future.size), "Serviços em destaque difere do número de marcações existente"

    @customer.schedules.each do |sc|
      if sc.id.in?(@customer.schedules.in_the_future.map(&:id))
        assert page.has_css?("div.service-scheduled > div:first-child > h5:first-child", text: "Serviço: #{sc.service.nome}"), "Serviço com horário marcado não destacado"
        assert page.has_no_css?("div.service > div:first-child > h5:first-child", text: "Serviço: #{sc.service.nome}"), "Serviço com horário marcado não destacado"

        assert page.has_css?("div.service-scheduled > div:first-child > h5:nth-child(4)", text: "Data: #{sc.datahora_inicio.strftime('%d/%m/%Y')}"), "Data não sendo exibida"
        assert page.has_no_css?("div.service > div:first-child > h5:nth-child(4)", text: "Data: #{sc.datahora_inicio.strftime('%d/%m/%Y')}"), "Data não sendo exibida"

        assert page.has_css?("div.service-scheduled > div:first-child > h5:nth-child(5)", text: "Hora: #{sc.datahora_inicio.strftime('%H:%M')}"), "Hora não sendo exibida"
        assert page.has_no_css?("div.service > div:first-child > h5:nth-child(5)", text: "Hora: #{sc.datahora_inicio.strftime('%H:%M')}"), "Hora não sendo exibida"
      else
        assert page.has_css?("div.service > div:first-child > h5:first-child", text: "Serviço: #{sc.service.nome}"), "Serviço sem horário marcado em destaque"
        assert page.has_no_css?("div.service-scheduled > div:first-child > h5:first-child", text: "Serviço: #{sc.service.nome}"), "Serviço sem horário marcado em destaque"

        assert page.has_no_css?("div.service > div:first-child > h5:nth-child(4)", text: "Data: #{sc.datahora_inicio.strftime('%d/%m/%Y')}"), "Serviço sem horário marcado mostrando data"
        assert page.has_no_css?("div.service-scheduled > div:first-child > h5:nth-child(4)", text: "Data: #{sc.datahora_inicio.strftime('%d/%m/%Y')}"), "Serviço sem horário marcado mostrando data"

        assert page.has_no_css?("div.service > div:first-child > h5:nth-child(5)", text: "Hora: #{sc.datahora_inicio.strftime('%H:%M')}"), "Serviço sem horário marcado mostrando hora"
        assert page.has_no_css?("div.service-scheduled > div:first-child > h5:nth-child(5)", text: "Hora: #{sc.datahora_inicio.strftime('%H:%M')}"), "Serviço sem horário marcado mostrando hora"
      end
    end
  end

  scenario "botões ativados para serviços com horário marcado, safiras suficientes no estabelecimento e solicitação não enviada" do
    @customer.schedules.each do |sc|
      if sc.id.in?(@customer.schedules.in_the_future.map(&:id)) && @customer.rewards.where(professional: sc.professional).first.total_safiras > sc.recompensa_divulgacao
        if sc.exchange_order_status.id == ExchangeOrderStatus.find_by_nome('inexistente').id
          assert page.has_no_css?("div.service-scheduled > div:nth-child(2) > a.btn-warning[disabled='disabled'][href='#{create_exchange_order_path(exchange_order: { schedule_id: sc.id })}']"), "Botão não ativo"
          assert page.has_css?("div.service-scheduled > div:nth-child(2) > a.btn-warning:not([disabled])[href='#{create_exchange_order_path(exchange_order: { schedule_id: sc.id })}']"), "Botão inexistente"
        else
          assert page.has_css?("div.service-scheduled > div:nth-child(2) > a.btn-warning[disabled='disabled'][href='#{new_exchange_order_path}']"), "Botão inexistente"
        end
      else
        assert page.has_no_css?("div.service > div:nth-child(2) > a.btn-warning:not([disabled])[href='#{create_exchange_order_path(exchange_order: { schedule_id: sc.id })}']"), "Botão não ativo"
        assert page.has_no_css?("div.service-scheduled > div:nth-child(2) > a.btn-warning:not([disabled])[href='#{create_exchange_order_path(exchange_order: { schedule_id: sc.id })}']"), "Botão inexistente"
      end
    end
  end

  scenario "Quantidade de Safiras por estabelecimento é exibida" do
    @professionals = @customer.professionals.distinct

    @professionals.each do |pr|
      assert page.has_css?('h3 strong', text: "#{pr.nome} (Suas Safiras: #{@customer.rewards.find_by_professional_id(pr.id).try(:total_safiras) || 0})"), "Não há informação de Safiras por Salão"
    end
  end

  scenario "botões desativados exibem mensagem de ajuda on:hrover", js: true do
    all('.dica')[0].hover
    assert page.has_selector?('h3', title="Que pena...", :visible => true)
  end

  scenario "botão é desativado, modal aparece e exchange_order_status é alterado quando solicitação é criada", js: true do
    sc = @customer.schedules.in_the_future.where('exchange_order_status_id = ?', ExchangeOrderStatus.find_by_nome('inexistente').id).first
    assert_equal ExchangeOrderStatus.find_by_nome('inexistente').id, sc.exchange_order_status_id, 'Status inicial de Solicitação de Troca diferente de inexistente'

    page.accept_alert 'Enviar Solicitação?' do
      page.find("div.service-scheduled > div:nth-child(2) > a.btn-warning:not([disabled])[href='#{create_exchange_order_path(exchange_order: { schedule_id: sc.id })}']").click
    end
    wait_for_ajax
    assert page.has_css?("div.service-scheduled > div:nth-child(2) > a.btn-warning[disabled='disabled'][href='#{create_exchange_order_path(exchange_order: { schedule_id: sc.id })}']"), "Botão não desativado após submissão de ordem"
    assert page.has_css?("#myModal", visible: true), "Modal sucesso não sendo exibido"

    sc = Schedule.find_by_id(sc.id)
    assert_equal ExchangeOrderStatus.find_by_nome('aguardando').id, sc.exchange_order_status_id, 'Status de Solicitação de Troca, após solicitação, diferente de aguardando'
  end
end