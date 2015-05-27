module Minitest::Assertions
  def allow(controller, action, msg=nil)
    assert permission.allow?(controller, action) == true, msg
  end
end

require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  describe "Professionals" do
    let(:deslogado) { Permission.new(nil) }
    let(:_testando) { Permission.new(professionals(:prof_testando)) }
    let(:bloqueado) { Permission.new(professionals(:prof_bloqueado)) }
    let(:suspenso)  { Permission.new(professionals(:prof_suspenso)) }
    let(:assinante) { Permission.new(professionals(:prof_assinante)) }

    test "deslogado" do
      assert_not deslogado.allow?("dashboard", "index"), "Profissional(deslogado) - dashboard#index - problemas na validação de permissão"
      assert_not deslogado.allow?("dashboard", "taken_steps"), "Profissional(deslogado) - dashboard#taken_steps - problemas na validação de permissão"

      assert deslogado.allow?("static_pages", "privacy"), "Profissional(deslogado) - static_pages#privacy - problemas na validação de permissão"

      assert deslogado.allow?("notifications", "new"), "Profissional(deslogado) - notifications#new - problemas na validação de permissão"
      assert deslogado.allow?("notifications", "retorno_pagamento"), "Profissional(deslogado) - notifications#retorno_pagamento - problemas na validação de permissão"

      assert_not deslogado.allow?("rewards", "get_customer_rewards"), "Profissional(deslogado) - rewards#get_customer_rewards - problemas na validação de permissão"

      assert deslogado.allow?("devise/sessions", "new"), "Profissional(deslogado) - devise/sessions#new - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/sessions", "create"), "Profissional(deslogado) - devise/sessions#create - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/sessions", "destroy"), "Profissional(deslogado) - devise/sessions#destroy - problemas na validação de permissão"

      assert deslogado.allow?("sessions", "new"), "Profissional(deslogado) - sessions#new - problemas na validação de permissão"
      assert deslogado.allow?("sessions", "create"), "Profissional(deslogado) - sessions#create - problemas na validação de permissão"
      assert deslogado.allow?("sessions", "destroy"), "Profissional(deslogado) - sessions#destroy - problemas na validação de permissão"
      assert_not deslogado.allow?("customer_omniauth_callbacks", "facebook"), "Profissional(deslogado) - customer_omniauth_callbacks#facebook - problemas na validação de permissão"

      assert deslogado.allow?("devise/passwords", "new"), "Profissional(deslogado) - devise/passwords#new - problemas na validação de permissão"
      assert deslogado.allow?("devise/passwords", "update"), "Profissional(deslogado) - devise/passwords#update - problemas na validação de permissão"
      assert deslogado.allow?("devise/passwords", "create"), "Profissional(deslogado) - devise/passwords#create - problemas na validação de permissão"
      assert deslogado.allow?("devise/passwords", "edit"), "Profissional(deslogado) - devise/passwords#edit - problemas na validação de permissão"
      
      assert_not deslogado.allow?("devise/registrations", "create"), "Profissional(deslogado) - devise/registrations#create - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/registrations", "new"), "Profissional(deslogado) - devise/registrations#new - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/registrations", "edit"), "Profissional(deslogado) - devise/registrations#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/registrations", "update"), "Profissional(deslogado) - devise/registrations#update - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/registrations", "cancel"), "Profissional(deslogado) - devise/registrations#cancel - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/registrations", "destroy"), "Profissional(deslogado) - devise/registrations#destroy - problemas na validação de permissão"

      assert deslogado.allow?("devise/professional_registrations", "create"), "Profissional(deslogado) - devise/professional_registrations#create - problemas na validação de permissão"
      assert deslogado.allow?("devise/professional_registrations", "new"), "Profissional(deslogado) - devise/professional_registrations#new - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/professional_registrations", "edit"), "Profissional(deslogado) - devise/professional_registrations#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/professional_registrations", "update"), "Profissional(deslogado) - devise/professional_registrations#update - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/professional_registrations", "cancel"), "Profissional(deslogado) - devise/professional_registrations#cancel - problemas na validação de permissão"
      assert_not deslogado.allow?("devise/professional_registrations", "destroy"), "Profissional(deslogado) - devise/professional_registrations#destroy - problemas na validação de permissão"

      assert_not deslogado.allow?("schedules", "new"), "Profissional(deslogado) - schedules#new - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "update"), "Profissional(deslogado) - schedules#update - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "index"), "Profissional(deslogado) - schedules#index - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "create"), "Profissional(deslogado) - schedules#create - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "edit"), "Profissional(deslogado) - schedules#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "show"), "Profissional(deslogado) - schedules#show - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "destroy"), "Profissional(deslogado) - schedules#destroy - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "new_exchange_order"), "Profissional(deslogado) - schedules#new_exchange_order - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "create_exchange_order"), "Profissional(deslogado) - schedules#create_exchange_order - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "get_last_two_months_scheduled_customers"), "Profissional(deslogado) - schedules#get_last_two_months_scheduled_customers - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "accept_exchange_order"), "Profissional(deslogado) - schedules#accept_exchange_order - problemas na validação de permissão"
      assert_not deslogado.allow?("schedules", "meus_servicos_por_profissionais"), "Profissional(deslogado) - schedules#meus_servicos_por_profissionais - problemas na validação de permissão"

      assert deslogado.allow?("customers", "new"), "Profissional(deslogado) - customers#new - problemas na validação de permissão"
      assert_not deslogado.allow?("customers", "update"), "Profissional(deslogado) - customers#update - problemas na validação de permissão"
      assert_not deslogado.allow?("customers", "index"), "Profissional(deslogado) - customers#index - problemas na validação de permissão"
      assert deslogado.allow?("customers", "create"), "Profissional(deslogado) - customers#create - problemas na validação de permissão"
      assert_not deslogado.allow?("customers", "edit"), "Profissional(deslogado) - customers#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("customers", "show"), "Profissional(deslogado) - customers#show - problemas na validação de permissão"
      assert_not deslogado.allow?("customers", "destroy"), "Profissional(deslogado) - customers#destroy - problemas na validação de permissão"
      assert_not deslogado.allow?("customers", "filter_by_email"), "Profissional(deslogado) - customers#filter_by_email - problemas na validação de permissão"
      assert_not deslogado.allow?("customers", "filter_by_telefone"), "Profissional(deslogado) - customers#filter_by_telefone - problemas na validação de permissão"

      assert_not deslogado.allow?("services", "new"), "Profissional(deslogado) - services#new - problemas na validação de permissão"
      assert_not deslogado.allow?("services", "update"), "Profissional(deslogado) - services#update - problemas na validação de permissão"
      assert_not deslogado.allow?("services", "index"), "Profissional(deslogado) - services#index - problemas na validação de permissão"
      assert_not deslogado.allow?("services", "create"), "Profissional(deslogado) - services#create - problemas na validação de permissão"
      assert_not deslogado.allow?("services", "edit"), "Profissional(deslogado) - services#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("services", "show"), "Profissional(deslogado) - services#show - problemas na validação de permissão"
      assert_not deslogado.allow?("services", "destroy"), "Profissional(deslogado) - services#destroy - problemas na validação de permissão"

      assert_not deslogado.allow?("statuses", "new"), "Profissional(deslogado) - statuses#new - problemas na validação de permissão"
      assert_not deslogado.allow?("statuses", "update"), "Profissional(deslogado) - statuses#update - problemas na validação de permissão"
      assert_not deslogado.allow?("statuses", "index"), "Profissional(deslogado) - statuses#index - problemas na validação de permissão"
      assert_not deslogado.allow?("statuses", "create"), "Profissional(deslogado) - statuses#create - problemas na validação de permissão"
      assert_not deslogado.allow?("statuses", "edit"), "Profissional(deslogado) - statuses#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("statuses", "show"), "Profissional(deslogado) - statuses#show - problemas na validação de permissão"
      assert_not deslogado.allow?("statuses", "destroy"), "Profissional(deslogado) - statuses#destroy - problemas na validação de permissão"

      assert_not deslogado.allow?("rewards", "new"), "Profissional(deslogado) - rewards#new - problemas na validação de permissão"
      assert_not deslogado.allow?("rewards", "update"), "Profissional(deslogado) - rewards#update - problemas na validação de permissão"
      assert_not deslogado.allow?("rewards", "index"), "Profissional(deslogado) - rewards#index - problemas na validação de permissão"
      assert_not deslogado.allow?("rewards", "create"), "Profissional(deslogado) - rewards#create - problemas na validação de permissão"
      assert_not deslogado.allow?("rewards", "edit"), "Profissional(deslogado) - rewards#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("rewards", "show"), "Profissional(deslogado) - rewards#show - problemas na validação de permissão"
      assert_not deslogado.allow?("rewards", "destroy"), "Profissional(deslogado) - rewards#destroy - problemas na validação de permissão"

      assert deslogado.allow?("devise/confirmations", "new"), "Profissional(deslogado) - devise/confirmations#new - problemas na validação de permissão"
      assert deslogado.allow?("devise/confirmations", "create"), "Profissional(deslogado) - devise/confirmations#create - problemas na validação de permissão"
      assert deslogado.allow?("devise/confirmations", "show"), "Profissional(deslogado) - devise/confirmations#show - problemas na validação de permissão"

      assert_not deslogado.allow?("photo_logs", "create"), "Profissional(deslogado) - photo_logs#create - problemas na validação de permissão"
      assert_not deslogado.allow?("photo_logs", "new"), "Profissional(deslogado) - photo_logs#new - problemas na validação de permissão"
      assert_not deslogado.allow?("photo_logs", "update"), "Profissional(deslogado) - photo_logs#update - problemas na validação de permissão"
      assert_not deslogado.allow?("photo_logs", "index"), "Profissional(deslogado) - photo_logs#index - problemas na validação de permissão"
      assert_not deslogado.allow?("photo_logs", "edit"), "Profissional(deslogado) - photo_logs#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("photo_logs", "show"), "Profissional(deslogado) - photo_logs#show - problemas na validação de permissão"
      assert_not deslogado.allow?("photo_logs", "destroy"), "Profissional(deslogado) - photo_logs#destroy - problemas na validação de permissão"
      assert_not deslogado.allow?("photo_logs", "send_to_fb"), "Profissional(deslogado) - photo_logs#send_to_fb - problemas na validação de permissão"

      assert_not deslogado.allow?("order_statuses", "new"), "Profissional(deslogado) - order_statuses#new - problemas na validação de permissão"
      assert_not deslogado.allow?("order_statuses", "update"), "Profissional(deslogado) - order_statuses#update - problemas na validação de permissão"
      assert_not deslogado.allow?("order_statuses", "index"), "Profissional(deslogado) - order_statuses#index - problemas na validação de permissão"
      assert_not deslogado.allow?("order_statuses", "create"), "Profissional(deslogado) - order_statuses#create - problemas na validação de permissão"
      assert_not deslogado.allow?("order_statuses", "edit"), "Profissional(deslogado) - order_statuses#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("order_statuses", "show"), "Profissional(deslogado) - order_statuses#show - problemas na validação de permissão"
      assert_not deslogado.allow?("order_statuses", "destroy"), "Profissional(deslogado) - order_statuses#destroy - problemas na validação de permissão"

      assert_not deslogado.allow?("professionals", "new"), "Profissional(deslogado) - professionals#new - problemas na validação de permissão"
      assert_not deslogado.allow?("professionals", "update"), "Profissional(deslogado) - professionals#update - problemas na validação de permissão"
      assert_not deslogado.allow?("professionals", "index"), "Profissional(deslogado) - professionals#index - problemas na validação de permissão"
      assert_not deslogado.allow?("professionals", "create"), "Profissional(deslogado) - professionals#create - problemas na validação de permissão"
      assert_not deslogado.allow?("professionals", "edit"), "Profissional(deslogado) - professionals#edit - problemas na validação de permissão"
      assert_not deslogado.allow?("professionals", "show"), "Profissional(deslogado) - professionals#show - problemas na validação de permissão"
      assert_not deslogado.allow?("professionals", "destroy"), "Profissional(deslogado) - professionals#destroy - problemas na validação de permissão"
    end

    test "testando" do
      assert_not _testando.allow?("dashboard", "index"), "Profissional(testando) - dashboard#index - problemas na validação de permissão"
      assert_not _testando.allow?("dashboard", "taken_steps"), "Profissional(testando) - dashboard#taken_steps - problemas na validação de permissão"

      assert _testando.allow?("static_pages", "privacy"), "Profissional(testando) - static_pages#privacy - problemas na validação de permissão"

      assert _testando.allow?("notifications", "new"), "Profissional(testando) - notifications#new - problemas na validação de permissão"
      assert _testando.allow?("notifications", "retorno_pagamento"), "Profissional(testando) - notifications#retorno_pagamento - problemas na validação de permissão"

      assert _testando.allow?("rewards", "get_customer_rewards"), "Profissional(testando) - rewards#get_customer_rewards - problemas na validação de permissão"

      assert _testando.allow?("schedules", "new"), "Profissional(testando) - schedules#new - problemas na validação de permissão"
      assert _testando.allow?("schedules", "update"), "Profissional(testando) - schedules#update - problemas na validação de permissão"
      assert _testando.allow?("schedules", "index"), "Profissional(testando) - schedules#index - problemas na validação de permissão"
      assert _testando.allow?("schedules", "create"), "Profissional(testando) - schedules#create - problemas na validação de permissão"
      assert _testando.allow?("schedules", "edit"), "Profissional(testando) - schedules#edit - problemas na validação de permissão"
      assert _testando.allow?("schedules", "show"), "Profissional(testando) - schedules#show - problemas na validação de permissão"
      assert _testando.allow?("schedules", "destroy"), "Profissional(testando) - schedules#destroy - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "new_exchange_order"), "Profissional(testando) - schedules#new_exchange_order - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "create_exchange_order"), "Profissional(testando) - schedules#create_exchange_order - problemas na validação de permissão"
      assert _testando.allow?("schedules", "get_last_two_months_scheduled_customers"), "Profissional(testando) - schedules#get_last_two_months_scheduled_customers - problemas na validação de permissão"
      assert_not _testando.allow?("schedules", "accept_exchange_order"), "Profissional(testando) - schedules#accept_exchange_order - problemas na validação de permissão"
      assert_not _testando.allow?("schedules", "meus_servicos_por_profissionais"), "Profissional(testando) - schedules#meus_servicos_por_profissionais - problemas na validação de permissão"

      assert_not _testando.allow?("devise/sessions", "new"), "Profissional(testando) - devise/sessions#new - problemas na validação de permissão"
      assert_not _testando.allow?("devise/sessions", "create"), "Profissional(testando) - devise/sessions#create - problemas na validação de permissão"
      assert_not _testando.allow?("devise/sessions", "destroy"), "Profissional(testando) - devise/sessions#destroy - problemas na validação de permissão"

      assert _testando.allow?("sessions", "new"), "Profissional(testando) - sessions#new - problemas na validação de permissão"
      assert _testando.allow?("sessions", "create"), "Profissional(testando) - sessions#create - problemas na validação de permissão"
      assert _testando.allow?("sessions", "destroy"), "Profissional(testando) - sessions#destroy - problemas na validação de permissão"
      assert_not _testando.allow?("customer_omniauth_callbacks", "facebook"), "Profissional(testando) - customer_omniauth_callbacks#facebook - problemas na validação de permissão"

      assert _testando.allow?("devise/passwords", "new"), "Profissional(testando) - devise/passwords#new - problemas na validação de permissão"
      assert _testando.allow?("devise/passwords", "update"), "Profissional(testando) - devise/passwords#update - problemas na validação de permissão"
      assert _testando.allow?("devise/passwords", "create"), "Profissional(testando) - devise/passwords#create - problemas na validação de permissão"
      assert _testando.allow?("devise/passwords", "edit"), "Profissional(testando) - devise/passwords#edit - problemas na validação de permissão"

      assert _testando.allow?("devise/confirmations", "new"), "Profissional(testando) - devise/confirmations#new - problemas na validação de permissão"
      assert _testando.allow?("devise/confirmations", "create"), "Profissional(testando) - devise/confirmations#create - problemas na validação de permissão"
      assert _testando.allow?("devise/confirmations", "show"), "Profissional(testando) - devise/confirmations#show - problemas na validação de permissão"

      assert_not _testando.allow?("devise/registrations", "create"), "Profissional(testando) - devise/registrations#create - problemas na validação de permissão"
      assert_not _testando.allow?("devise/registrations", "new"), "Profissional(testando) - devise/registrations#new - problemas na validação de permissão"
      assert_not _testando.allow?("devise/registrations", "edit"), "Profissional(testando) - devise/registrations#edit - problemas na validação de permissão"
      assert_not _testando.allow?("devise/registrations", "update"), "Profissional(testando) - devise/registrations#update - problemas na validação de permissão"
      assert_not _testando.allow?("devise/registrations", "cancel"), "Profissional(testando) - devise/registrations#cancel - problemas na validação de permissão"
      assert_not _testando.allow?("devise/registrations", "destroy"), "Profissional(testando) - devise/registrations#destroy - problemas na validação de permissão"

      assert _testando.allow?("devise/professional_registrations", "create"), "Profissional(_testando) - devise/professional_registrations#create - problemas na validação de permissão"
      assert _testando.allow?("devise/professional_registrations", "new"), "Profissional(_testando) - devise/professional_registrations#new - problemas na validação de permissão"
      assert _testando.allow?("devise/professional_registrations", "edit"), "Profissional(_testando) - devise/professional_registrations#edit - problemas na validação de permissão"
      assert _testando.allow?("devise/professional_registrations", "update"), "Profissional(_testando) - devise/professional_registrations#update - problemas na validação de permissão"
      assert_not _testando.allow?("devise/professional_registrations", "cancel"), "Profissional(_testando) - devise/professional_registrations#cancel - problemas na validação de permissão"
      assert_not _testando.allow?("devise/professional_registrations", "destroy"), "Profissional(_testando) - devise/professional_registrations#destroy - problemas na validação de permissão"

      assert _testando.allow?("services", "new"), "Profissional(testando) - services#new - problemas na validação de permissão"
      assert _testando.allow?("services", "update"), "Profissional(testando) - services#update - problemas na validação de permissão"
      assert _testando.allow?("services", "index"), "Profissional(testando) - services#index - problemas na validação de permissão"
      assert _testando.allow?("services", "create"), "Profissional(testando) - services#create - problemas na validação de permissão"
      assert _testando.allow?("services", "edit"), "Profissional(testando) - services#edit - problemas na validação de permissão"
      assert _testando.allow?("services", "show"), "Profissional(testando) - services#show - problemas na validação de permissão"
      assert _testando.allow?("services", "destroy"), "Profissional(testando) - services#destroy - problemas na validação de permissão"

      assert _testando.allow?("customers", "new"), "Profissional(testando) - customers#new - problemas na validação de permissão"
      assert_not _testando.allow?("customers", "update"), "Profissional(testando) - customers#update - problemas na validação de permissão"
      assert_not _testando.allow?("customers", "index"), "Profissional(testando) - customers#index - problemas na validação de permissão"
      assert _testando.allow?("customers", "create"), "Profissional(testando) - customers#create - problemas na validação de permissão"
      assert_not _testando.allow?("customers", "edit"), "Profissional(testando) - customers#edit - problemas na validação de permissão"
      assert_not _testando.allow?("customers", "show"), "Profissional(testando) - customers#show - problemas na validação de permissão"
      assert_not _testando.allow?("customers", "destroy"), "Profissional(testando) - customers#destroy - problemas na validação de permissão"
      assert _testando.allow?("customers", "filter_by_email"), "Profissional(testando) - customers#filter_by_email - problemas na validação de permissão"
      assert _testando.allow?("customers", "filter_by_telefone"), "Profissional(testando) - customers#filter_by_telefone - problemas na validação de permissão"

      assert_not _testando.allow?("statuses", "new"), "Profissional(testando) - statuses#new - problemas na validação de permissão"
      assert_not _testando.allow?("statuses", "update"), "Profissional(testando) - statuses#update - problemas na validação de permissão"
      assert_not _testando.allow?("statuses", "index"), "Profissional(testando) - statuses#index - problemas na validação de permissão"
      assert_not _testando.allow?("statuses", "create"), "Profissional(testando) - statuses#create - problemas na validação de permissão"
      assert_not _testando.allow?("statuses", "edit"), "Profissional(testando) - statuses#edit - problemas na validação de permissão"
      assert_not _testando.allow?("statuses", "show"), "Profissional(testando) - statuses#show - problemas na validação de permissão"
      assert_not _testando.allow?("statuses", "destroy"), "Profissional(testando) - statuses#destroy - problemas na validação de permissão"

      assert_not _testando.allow?("rewards", "new"), "Profissional(testando) - rewards#new - problemas na validação de permissão"
      assert_not _testando.allow?("rewards", "update"), "Profissional(testando) - rewards#update - problemas na validação de permissão"
      assert_not _testando.allow?("rewards", "index"), "Profissional(testando) - rewards#index - problemas na validação de permissão"
      assert_not _testando.allow?("rewards", "create"), "Profissional(testando) - rewards#create - problemas na validação de permissão"
      assert_not _testando.allow?("rewards", "edit"), "Profissional(testando) - rewards#edit - problemas na validação de permissão"
      assert_not _testando.allow?("rewards", "show"), "Profissional(testando) - rewards#show - problemas na validação de permissão"
      assert_not _testando.allow?("rewards", "destroy"), "Profissional(testando) - rewards#destroy - problemas na validação de permissão"

      assert_not _testando.allow?("photo_logs", "create"), "Profissional(testando) - photo_logs#create - problemas na validação de permissão"
      assert_not _testando.allow?("photo_logs", "new"), "Profissional(testando) - photo_logs#new - problemas na validação de permissão"
      assert_not _testando.allow?("photo_logs", "update"), "Profissional(testando) - photo_logs#update - problemas na validação de permissão"
      assert_not _testando.allow?("photo_logs", "index"), "Profissional(testando) - photo_logs#index - problemas na validação de permissão"
      assert_not _testando.allow?("photo_logs", "edit"), "Profissional(testando) - photo_logs#edit - problemas na validação de permissão"
      assert_not _testando.allow?("photo_logs", "show"), "Profissional(testando) - photo_logs#show - problemas na validação de permissão"
      assert_not _testando.allow?("photo_logs", "destroy"), "Profissional(testando) - photo_logs#destroy - problemas na validação de permissão"
      assert_not _testando.allow?("photo_logs", "send_to_fb"), "Profissional(testando) - photo_logs#send_to_fb - problemas na validação de permissão"

      assert_not _testando.allow?("order_statuses", "new"), "Profissional(testando) - order_statuses#new - problemas na validação de permissão"
      assert_not _testando.allow?("order_statuses", "update"), "Profissional(testando) - order_statuses#update - problemas na validação de permissão"
      assert_not _testando.allow?("order_statuses", "index"), "Profissional(testando) - order_statuses#index - problemas na validação de permissão"
      assert_not _testando.allow?("order_statuses", "create"), "Profissional(testando) - order_statuses#create - problemas na validação de permissão"
      assert_not _testando.allow?("order_statuses", "edit"), "Profissional(testando) - order_statuses#edit - problemas na validação de permissão"
      assert_not _testando.allow?("order_statuses", "show"), "Profissional(testando) - order_statuses#show - problemas na validação de permissão"
      assert_not _testando.allow?("order_statuses", "destroy"), "Profissional(testando) - order_statuses#destroy - problemas na validação de permissão"

      assert_not _testando.allow?("professionals", "new"), "Profissional(testando) - professionals#new - problemas na validação de permissão"
      assert_not _testando.allow?("professionals", "update"), "Profissional(testando) - professionals#update - problemas na validação de permissão"
      assert_not _testando.allow?("professionals", "index"), "Profissional(testando) - professionals#index - problemas na validação de permissão"
      assert_not _testando.allow?("professionals", "create"), "Profissional(testando) - professionals#create - problemas na validação de permissão"
      assert_not _testando.allow?("professionals", "edit"), "Profissional(testando) - professionals#edit - problemas na validação de permissão"
      assert_not _testando.allow?("professionals", "show"), "Profissional(testando) - professionals#show - problemas na validação de permissão"
      assert_not _testando.allow?("professionals", "destroy"), "Profissional(testando) - professionals#destroy - problemas na validação de permissão"
    end

    test "bloqueado" do
      assert_not bloqueado.allow?("dashboard", "index"), "Profissional(bloqueado) - dashboard#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("dashboard", "taken_steps"), "Profissional(bloqueado) - dashboard#taken_steps - problemas na validação de permissão"

      assert bloqueado.allow?("static_pages", "privacy"), "Profissional(bloqueado) - static_pages#privacy - problemas na validação de permissão"

      assert bloqueado.allow?("notifications", "new"), "Profissional(bloqueado) - notifications#new - problemas na validação de permissão"
      assert bloqueado.allow?("notifications", "retorno_pagamento"), "Profissional(bloqueado) - notifications#retorno_pagamento - problemas na validação de permissão"

      assert_not bloqueado.allow?("rewards", "get_customer_rewards"), "Profissional(bloqueado) - rewards#get_customer_rewards - problemas na validação de permissão"

      assert     bloqueado.allow?("schedules", "new"), "Profissional(bloqueado) - schedules#new - problemas na validação de permissão"
      assert     bloqueado.allow?("schedules", "index"), "Profissional(bloqueado) - schedules#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "update"), "Profissional(bloqueado) - schedules#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "create"), "Profissional(bloqueado) - schedules#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "edit"), "Profissional(bloqueado) - schedules#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "show"), "Profissional(bloqueado) - schedules#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "destroy"), "Profissional(bloqueado) - schedules#destroy - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "new_exchange_order"), "Profissional(bloqueado) - schedules#new_exchange_order - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "create_exchange_order"), "Profissional(bloqueado) - schedules#create_exchange_order - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "get_last_two_months_scheduled_customers"), "Profissional(bloqueado) - schedules#get_last_two_months_scheduled_customers - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "accept_exchange_order"), "Profissional(bloqueado) - schedules#accept_exchange_order - problemas na validação de permissão"
      assert_not bloqueado.allow?("schedules", "meus_servicos_por_profissionais"), "Profissional(bloqueado) - schedules#meus_servicos_por_profissionais - problemas na validação de permissão"

      assert_not bloqueado.allow?("devise/sessions", "new"), "Profissional(bloqueado) - devise/sessions#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/sessions", "create"), "Profissional(bloqueado) - devise/sessions#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/sessions", "destroy"), "Profissional(bloqueado) - devise/sessions#destroy - problemas na validação de permissão"

      assert bloqueado.allow?("sessions", "new"), "Profissional(bloqueado) - sessions#new - problemas na validação de permissão"
      assert bloqueado.allow?("sessions", "create"), "Profissional(bloqueado) - sessions#create - problemas na validação de permissão"
      assert bloqueado.allow?("sessions", "destroy"), "Profissional(bloqueado) - sessions#destroy - problemas na validação de permissão"
      assert_not bloqueado.allow?("customer_omniauth_callbacks", "facebook"), "Profissional(bloqueado) - customer_omniauth_callbacks#facebook - problemas na validação de permissão"

      assert bloqueado.allow?("devise/passwords", "new"), "Profissional(bloqueado) - devise/passwords#new - problemas na validação de permissão"
      assert bloqueado.allow?("devise/passwords", "update"), "Profissional(bloqueado) - devise/passwords#update - problemas na validação de permissão"
      assert bloqueado.allow?("devise/passwords", "create"), "Profissional(bloqueado) - devise/passwords#create - problemas na validação de permissão"
      assert bloqueado.allow?("devise/passwords", "edit"), "Profissional(bloqueado) - devise/passwords#edit - problemas na validação de permissão"

      assert bloqueado.allow?("devise/confirmations", "new"), "Profissional(bloqueado) - devise/confirmations#new - problemas na validação de permissão"
      assert bloqueado.allow?("devise/confirmations", "create"), "Profissional(bloqueado) - devise/confirmations#create - problemas na validação de permissão"
      assert bloqueado.allow?("devise/confirmations", "show"), "Profissional(bloqueado) - devise/confirmations#show - problemas na validação de permissão"

      assert_not bloqueado.allow?("devise/registrations", "create"), "Profissional(bloqueado) - devise/registrations#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/registrations", "new"), "Profissional(bloqueado) - devise/registrations#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/registrations", "edit"), "Profissional(bloqueado) - devise/registrations#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/registrations", "update"), "Profissional(bloqueado) - devise/registrations#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/registrations", "cancel"), "Profissional(bloqueado) - devise/registrations#cancel - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/registrations", "destroy"), "Profissional(bloqueado) - devise/registrations#destroy - problemas na validação de permissão"

      assert bloqueado.allow?("devise/professional_registrations", "create"), "Profissional(bloqueado) - devise/professional_registrations#create - problemas na validação de permissão"
      assert bloqueado.allow?("devise/professional_registrations", "new"), "Profissional(bloqueado) - devise/professional_registrations#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/professional_registrations", "edit"), "Profissional(bloqueado) - devise/professional_registrations#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/professional_registrations", "update"), "Profissional(bloqueado) - devise/professional_registrations#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/professional_registrations", "cancel"), "Profissional(bloqueado) - devise/professional_registrations#cancel - problemas na validação de permissão"
      assert_not bloqueado.allow?("devise/professional_registrations", "destroy"), "Profissional(bloqueado) - devise/professional_registrations#destroy - problemas na validação de permissão"

      assert_not bloqueado.allow?("services", "new"), "Profissional(bloqueado) - services#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("services", "update"), "Profissional(bloqueado) - services#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("services", "index"), "Profissional(bloqueado) - services#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("services", "create"), "Profissional(bloqueado) - services#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("services", "edit"), "Profissional(bloqueado) - services#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("services", "show"), "Profissional(bloqueado) - services#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("services", "destroy"), "Profissional(bloqueado) - services#destroy - problemas na validação de permissão"

      assert bloqueado.allow?("customers", "new"), "Profissional(bloqueado) - customers#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("customers", "update"), "Profissional(bloqueado) - customers#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("customers", "index"), "Profissional(bloqueado) - customers#index - problemas na validação de permissão"
      assert bloqueado.allow?("customers", "create"), "Profissional(bloqueado) - customers#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("customers", "edit"), "Profissional(bloqueado) - customers#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("customers", "show"), "Profissional(bloqueado) - customers#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("customers", "destroy"), "Profissional(bloqueado) - customers#destroy - problemas na validação de permissão"
      assert_not bloqueado.allow?("customers", "filter_by_email"), "Profissional(bloqueado) - customers#filter_by_email - problemas na validação de permissão"
      assert_not bloqueado.allow?("customers", "filter_by_telefone"), "Profissional(bloqueado) - customers#filter_by_telefone - problemas na validação de permissão"

      assert_not bloqueado.allow?("statuses", "new"), "Profissional(bloqueado) - statuses#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("statuses", "update"), "Profissional(bloqueado) - statuses#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("statuses", "index"), "Profissional(bloqueado) - statuses#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("statuses", "create"), "Profissional(bloqueado) - statuses#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("statuses", "edit"), "Profissional(bloqueado) - statuses#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("statuses", "show"), "Profissional(bloqueado) - statuses#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("statuses", "destroy"), "Profissional(bloqueado) - statuses#destroy - problemas na validação de permissão"

      assert_not bloqueado.allow?("rewards", "new"), "Profissional(bloqueado) - rewards#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("rewards", "update"), "Profissional(bloqueado) - rewards#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("rewards", "index"), "Profissional(bloqueado) - rewards#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("rewards", "create"), "Profissional(bloqueado) - rewards#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("rewards", "edit"), "Profissional(bloqueado) - rewards#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("rewards", "show"), "Profissional(bloqueado) - rewards#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("rewards", "destroy"), "Profissional(bloqueado) - rewards#destroy - problemas na validação de permissão"

      assert_not bloqueado.allow?("photo_logs", "create"), "Profissional(bloqueado) - photo_logs#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("photo_logs", "new"), "Profissional(bloqueado) - photo_logs#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("photo_logs", "update"), "Profissional(bloqueado) - photo_logs#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("photo_logs", "index"), "Profissional(bloqueado) - photo_logs#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("photo_logs", "edit"), "Profissional(bloqueado) - photo_logs#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("photo_logs", "show"), "Profissional(bloqueado) - photo_logs#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("photo_logs", "destroy"), "Profissional(bloqueado) - photo_logs#destroy - problemas na validação de permissão"
      assert_not bloqueado.allow?("photo_logs", "send_to_fb"), "Profissional(bloqueado) - photo_logs#send_to_fb - problemas na validação de permissão"

      assert_not bloqueado.allow?("order_statuses", "new"), "Profissional(bloqueado) - order_statuses#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("order_statuses", "update"), "Profissional(bloqueado) - order_statuses#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("order_statuses", "index"), "Profissional(bloqueado) - order_statuses#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("order_statuses", "create"), "Profissional(bloqueado) - order_statuses#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("order_statuses", "edit"), "Profissional(bloqueado) - order_statuses#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("order_statuses", "show"), "Profissional(bloqueado) - order_statuses#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("order_statuses", "destroy"), "Profissional(bloqueado) - order_statuses#destroy - problemas na validação de permissão"

      assert_not bloqueado.allow?("professionals", "new"), "Profissional(bloqueado) - professionals#new - problemas na validação de permissão"
      assert_not bloqueado.allow?("professionals", "update"), "Profissional(bloqueado) - professionals#update - problemas na validação de permissão"
      assert_not bloqueado.allow?("professionals", "index"), "Profissional(bloqueado) - professionals#index - problemas na validação de permissão"
      assert_not bloqueado.allow?("professionals", "create"), "Profissional(bloqueado) - professionals#create - problemas na validação de permissão"
      assert_not bloqueado.allow?("professionals", "edit"), "Profissional(bloqueado) - professionals#edit - problemas na validação de permissão"
      assert_not bloqueado.allow?("professionals", "show"), "Profissional(bloqueado) - professionals#show - problemas na validação de permissão"
      assert_not bloqueado.allow?("professionals", "destroy"), "Profissional(bloqueado) - professionals#destroy - problemas na validação de permissão"
    end

    test "suspenso" do
      assert_not suspenso.allow?("dashboard", "index"), "Profissional(suspenso) - dashboard#index - problemas na validação de permissão"
      assert_not suspenso.allow?("dashboard", "taken_steps"), "Profissional(suspenso) - dashboard#taken_steps - problemas na validação de permissão"

      assert suspenso.allow?("static_pages", "privacy"), "Profissional(suspenso) - static_pages#privacy - problemas na validação de permissão"

      assert suspenso.allow?("notifications", "new"), "Profissional(suspenso) - notifications#new - problemas na validação de permissão"
      assert suspenso.allow?("notifications", "retorno_pagamento"), "Profissional(suspenso) - notifications#retorno_pagamento - problemas na validação de permissão"

      assert_not suspenso.allow?("rewards", "get_customer_rewards"), "Profissional(suspenso) - rewards#get_customer_rewards - problemas na validação de permissão"

      assert suspenso.allow?("schedules", "new"), "Profissional(suspenso) - schedules#new - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "destroy"), "Profissional(suspenso) - schedules#destroy - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "update"), "Profissional(suspenso) - schedules#update - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "index"), "Profissional(suspenso) - schedules#index - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "create"), "Profissional(suspenso) - schedules#create - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "edit"), "Profissional(suspenso) - schedules#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "show"), "Profissional(suspenso) - schedules#show - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "new_exchange_order"), "Profissional(suspenso) - schedules#new_exchange_order - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "create_exchange_order"), "Profissional(suspenso) - schedules#create_exchange_order - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "get_last_two_months_scheduled_customers"), "Profissional(suspenso) - schedules#get_last_two_months_scheduled_customers - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "accept_exchange_order"), "Profissional(suspenso) - schedules#accept_exchange_order - problemas na validação de permissão"
      assert_not suspenso.allow?("schedules", "meus_servicos_por_profissionais"), "Profissional(suspenso) - schedules#meus_servicos_por_profissionais - problemas na validação de permissão"

      assert_not suspenso.allow?("devise/sessions", "new"), "Profissional(suspenso) - devise/sessions#new - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/sessions", "create"), "Profissional(suspenso) - devise/sessions#create - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/sessions", "destroy"), "Profissional(suspenso) - devise/sessions#destroy - problemas na validação de permissão"
      assert_not suspenso.allow?("customer_omniauth_callbacks", "facebook"), "Profissional(suspenso) - customer_omniauth_callbacks#facebook - problemas na validação de permissão"

      assert suspenso.allow?("sessions", "new"), "Profissional(suspenso) - sessions#new - problemas na validação de permissão"
      assert suspenso.allow?("sessions", "create"), "Profissional(suspenso) - sessions#create - problemas na validação de permissão"
      assert suspenso.allow?("sessions", "destroy"), "Profissional(suspenso) - sessions#destroy - problemas na validação de permissão"

      assert suspenso.allow?("devise/passwords", "new"), "Profissional(suspenso) - devise/passwords#new - problemas na validação de permissão"
      assert suspenso.allow?("devise/passwords", "update"), "Profissional(suspenso) - devise/passwords#update - problemas na validação de permissão"
      assert suspenso.allow?("devise/passwords", "create"), "Profissional(suspenso) - devise/passwords#create - problemas na validação de permissão"
      assert suspenso.allow?("devise/passwords", "edit"), "Profissional(suspenso) - devise/passwords#edit - problemas na validação de permissão"

      assert suspenso.allow?("devise/confirmations", "new"), "Profissional(suspenso) - devise/confirmations#new - problemas na validação de permissão"
      assert suspenso.allow?("devise/confirmations", "create"), "Profissional(suspenso) - devise/confirmations#create - problemas na validação de permissão"
      assert suspenso.allow?("devise/confirmations", "show"), "Profissional(suspenso) - devise/confirmations#show - problemas na validação de permissão"

      assert_not suspenso.allow?("devise/registrations", "create"), "Profissional(suspenso) - devise/registrations#create - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/registrations", "new"), "Profissional(suspenso) - devise/registrations#new - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/registrations", "edit"), "Profissional(suspenso) - devise/registrations#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/registrations", "update"), "Profissional(suspenso) - devise/registrations#update - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/registrations", "cancel"), "Profissional(suspenso) - devise/registrations#cancel - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/registrations", "destroy"), "Profissional(suspenso) - devise/registrations#destroy - problemas na validação de permissão"

      assert suspenso.allow?("devise/professional_registrations", "create"), "Profissional(suspenso) - devise/professional_registrations#create - problemas na validação de permissão"
      assert suspenso.allow?("devise/professional_registrations", "new"), "Profissional(suspenso) - devise/professional_registrations#new - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/professional_registrations", "edit"), "Profissional(suspenso) - devise/professional_registrations#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/professional_registrations", "update"), "Profissional(suspenso) - devise/professional_registrations#update - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/professional_registrations", "cancel"), "Profissional(suspenso) - devise/professional_registrations#cancel - problemas na validação de permissão"
      assert_not suspenso.allow?("devise/professional_registrations", "destroy"), "Profissional(suspenso) - devise/professional_registrations#destroy - problemas na validação de permissão"

      assert_not suspenso.allow?("services", "new"), "Profissional(suspenso) - services#new - problemas na validação de permissão"
      assert_not suspenso.allow?("services", "update"), "Profissional(suspenso) - services#update - problemas na validação de permissão"
      assert_not suspenso.allow?("services", "index"), "Profissional(suspenso) - services#index - problemas na validação de permissão"
      assert_not suspenso.allow?("services", "create"), "Profissional(suspenso) - services#create - problemas na validação de permissão"
      assert_not suspenso.allow?("services", "edit"), "Profissional(suspenso) - services#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("services", "show"), "Profissional(suspenso) - services#show - problemas na validação de permissão"
      assert_not suspenso.allow?("services", "destroy"), "Profissional(suspenso) - services#destroy - problemas na validação de permissão"

      assert suspenso.allow?("customers", "new"), "Profissional(suspenso) - customers#new - problemas na validação de permissão"
      assert_not suspenso.allow?("customers", "update"), "Profissional(suspenso) - customers#update - problemas na validação de permissão"
      assert_not suspenso.allow?("customers", "index"), "Profissional(suspenso) - customers#index - problemas na validação de permissão"
      assert suspenso.allow?("customers", "create"), "Profissional(suspenso) - customers#create - problemas na validação de permissão"
      assert_not suspenso.allow?("customers", "edit"), "Profissional(suspenso) - customers#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("customers", "show"), "Profissional(suspenso) - customers#show - problemas na validação de permissão"
      assert_not suspenso.allow?("customers", "destroy"), "Profissional(suspenso) - customers#destroy - problemas na validação de permissão"
      assert_not suspenso.allow?("customers", "filter_by_email"), "Profissional(suspenso) - customers#filter_by_email - problemas na validação de permissão"
      assert_not suspenso.allow?("customers", "filter_by_telefone"), "Profissional(suspenso) - customers#filter_by_telefone - problemas na validação de permissão"

      assert_not suspenso.allow?("statuses", "new"), "Profissional(suspenso) - statuses#new - problemas na validação de permissão"
      assert_not suspenso.allow?("statuses", "update"), "Profissional(suspenso) - statuses#update - problemas na validação de permissão"
      assert_not suspenso.allow?("statuses", "index"), "Profissional(suspenso) - statuses#index - problemas na validação de permissão"
      assert_not suspenso.allow?("statuses", "create"), "Profissional(suspenso) - statuses#create - problemas na validação de permissão"
      assert_not suspenso.allow?("statuses", "edit"), "Profissional(suspenso) - statuses#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("statuses", "show"), "Profissional(suspenso) - statuses#show - problemas na validação de permissão"
      assert_not suspenso.allow?("statuses", "destroy"), "Profissional(suspenso) - statuses#destroy - problemas na validação de permissão"

      assert_not suspenso.allow?("rewards", "new"), "Profissional(suspenso) - rewards#new - problemas na validação de permissão"
      assert_not suspenso.allow?("rewards", "update"), "Profissional(suspenso) - rewards#update - problemas na validação de permissão"
      assert_not suspenso.allow?("rewards", "index"), "Profissional(suspenso) - rewards#index - problemas na validação de permissão"
      assert_not suspenso.allow?("rewards", "create"), "Profissional(suspenso) - rewards#create - problemas na validação de permissão"
      assert_not suspenso.allow?("rewards", "edit"), "Profissional(suspenso) - rewards#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("rewards", "show"), "Profissional(suspenso) - rewards#show - problemas na validação de permissão"
      assert_not suspenso.allow?("rewards", "destroy"), "Profissional(suspenso) - rewards#destroy - problemas na validação de permissão"

      assert_not suspenso.allow?("photo_logs", "create"), "Profissional(suspenso) - photo_logs#create - problemas na validação de permissão"
      assert_not suspenso.allow?("photo_logs", "new"), "Profissional(suspenso) - photo_logs#new - problemas na validação de permissão"
      assert_not suspenso.allow?("photo_logs", "update"), "Profissional(suspenso) - photo_logs#update - problemas na validação de permissão"
      assert_not suspenso.allow?("photo_logs", "index"), "Profissional(suspenso) - photo_logs#index - problemas na validação de permissão"
      assert_not suspenso.allow?("photo_logs", "edit"), "Profissional(suspenso) - photo_logs#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("photo_logs", "show"), "Profissional(suspenso) - photo_logs#show - problemas na validação de permissão"
      assert_not suspenso.allow?("photo_logs", "destroy"), "Profissional(suspenso) - photo_logs#destroy - problemas na validação de permissão"
      assert_not suspenso.allow?("photo_logs", "send_to_fb"), "Profissional(suspenso) - photo_logs#send_to_fb - problemas na validação de permissão"

      assert_not suspenso.allow?("order_statuses", "new"), "Profissional(suspenso) - order_statuses#new - problemas na validação de permissão"
      assert_not suspenso.allow?("order_statuses", "update"), "Profissional(suspenso) - order_statuses#update - problemas na validação de permissão"
      assert_not suspenso.allow?("order_statuses", "index"), "Profissional(suspenso) - order_statuses#index - problemas na validação de permissão"
      assert_not suspenso.allow?("order_statuses", "create"), "Profissional(suspenso) - order_statuses#create - problemas na validação de permissão"
      assert_not suspenso.allow?("order_statuses", "edit"), "Profissional(suspenso) - order_statuses#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("order_statuses", "show"), "Profissional(suspenso) - order_statuses#show - problemas na validação de permissão"
      assert_not suspenso.allow?("order_statuses", "destroy"), "Profissional(suspenso) - order_statuses#destroy - problemas na validação de permissão"

      assert_not suspenso.allow?("professionals", "new"), "Profissional(suspenso) - professionals#new - problemas na validação de permissão"
      assert_not suspenso.allow?("professionals", "update"), "Profissional(suspenso) - professionals#update - problemas na validação de permissão"
      assert_not suspenso.allow?("professionals", "index"), "Profissional(suspenso) - professionals#index - problemas na validação de permissão"
      assert_not suspenso.allow?("professionals", "create"), "Profissional(suspenso) - professionals#create - problemas na validação de permissão"
      assert_not suspenso.allow?("professionals", "edit"), "Profissional(suspenso) - professionals#edit - problemas na validação de permissão"
      assert_not suspenso.allow?("professionals", "show"), "Profissional(suspenso) - professionals#show - problemas na validação de permissão"
      assert_not suspenso.allow?("professionals", "destroy"), "Profissional(suspenso) - professionals#destroy - problemas na validação de permissão"
    end

    test "assinante" do
      assert_not assinante.allow?("dashboard", "index"), "Profissional(assinante) - dashboard#index - problemas na validação de permissão"
      assert_not assinante.allow?("dashboard", "taken_steps"), "Profissional(assinante) - dashboard#taken_steps - problemas na validação de permissão"

      assert assinante.allow?("static_pages", "privacy"), "Profissional(assinante) - static_pages#privacy - problemas na validação de permissão"

      assert assinante.allow?("notifications", "new"), "Profissional(assinante) - notifications#new - problemas na validação de permissão"
      assert assinante.allow?("notifications", "retorno_pagamento"), "Profissional(assinante) - notifications#retorno_pagamento - problemas na validação de permissão"

      assert assinante.allow?("rewards", "get_customer_rewards"), "Profissional(assinante) - rewards#get_customer_rewards - problemas na validação de permissão"

      assert assinante.allow?("schedules", "new"), "Profissional(assinante) - schedules#new - problemas na validação de permissão"
      assert assinante.allow?("schedules", "update"), "Profissional(assinante) - schedules#update - problemas na validação de permissão"
      assert assinante.allow?("schedules", "index"), "Profissional(assinante) - schedules#index - problemas na validação de permissão"
      assert assinante.allow?("schedules", "create"), "Profissional(assinante) - schedules#create - problemas na validação de permissão"
      assert assinante.allow?("schedules", "edit"), "Profissional(assinante) - schedules#edit - problemas na validação de permissão"
      assert assinante.allow?("schedules", "show"), "Profissional(assinante) - schedules#show - problemas na validação de permissão"
      assert assinante.allow?("schedules", "destroy"), "Profissional(assinante) - schedules#destroy - problemas na validação de permissão"
      assert_not assinante.allow?("schedules", "new_exchange_order"), "Profissional(assinante) - schedules#new_exchange_order - problemas na validação de permissão"
      assert_not assinante.allow?("schedules", "create_exchange_order"), "Profissional(assinante) - schedules#create_exchange_order - problemas na validação de permissão"
      assert assinante.allow?("schedules", "get_last_two_months_scheduled_customers"), "Profissional(assinante) - schedules#get_last_two_months_scheduled_customers - problemas na validação de permissão"
      assert_not assinante.allow?("schedules", "accept_exchange_order"), "Profissional(assinante) - schedules#accept_exchange_order - problemas na validação de permissão"
      assert_not assinante.allow?("schedules", "meus_servicos_por_profissionais"), "Profissional(assinante) - schedules#meus_servicos_por_profissionais - problemas na validação de permissão"

      assert_not assinante.allow?("devise/sessions", "new"), "Profissional(assinante) - devise/sessions#new - problemas na validação de permissão"
      assert_not assinante.allow?("devise/sessions", "create"), "Profissional(assinante) - devise/sessions#create - problemas na validação de permissão"
      assert_not assinante.allow?("devise/sessions", "destroy"), "Profissional(assinante) - devise/sessions#destroy - problemas na validação de permissão"

      assert assinante.allow?("sessions", "new"), "Profissional(assinante) - sessions#new - problemas na validação de permissão"
      assert assinante.allow?("sessions", "create"), "Profissional(assinante) - sessions#create - problemas na validação de permissão"
      assert assinante.allow?("sessions", "destroy"), "Profissional(assinante) - sessions#destroy - problemas na validação de permissão"
      assert_not assinante.allow?("customer_omniauth_callbacks", "facebook"), "Profissional(assinante) - customer_omniauth_callbacks#facebook - problemas na validação de permissão"

      assert assinante.allow?("devise/passwords", "new"), "Profissional(assinante) - devise/passwords#new - problemas na validação de permissão"
      assert assinante.allow?("devise/passwords", "update"), "Profissional(assinante) - devise/passwords#update - problemas na validação de permissão"
      assert assinante.allow?("devise/passwords", "create"), "Profissional(assinante) - devise/passwords#create - problemas na validação de permissão"
      assert assinante.allow?("devise/passwords", "edit"), "Profissional(assinante) - devise/passwords#edit - problemas na validação de permissão"

      assert assinante.allow?("devise/confirmations", "new"), "Profissional(assinante) - devise/confirmations#new - problemas na validação de permissão"
      assert assinante.allow?("devise/confirmations", "create"), "Profissional(assinante) - devise/confirmations#create - problemas na validação de permissão"
      assert assinante.allow?("devise/confirmations", "show"), "Profissional(assinante) - devise/confirmations#show - problemas na validação de permissão"

      assert_not assinante.allow?("devise/registrations", "create"), "Profissional(assinante) - devise/registrations#create - problemas na validação de permissão"
      assert_not assinante.allow?("devise/registrations", "new"), "Profissional(assinante) - devise/registrations#new - problemas na validação de permissão"
      assert_not assinante.allow?("devise/registrations", "edit"), "Profissional(assinante) - devise/registrations#edit - problemas na validação de permissão"
      assert_not assinante.allow?("devise/registrations", "update"), "Profissional(assinante) - devise/registrations#update - problemas na validação de permissão"
      assert_not assinante.allow?("devise/registrations", "cancel"), "Profissional(assinante) - devise/registrations#cancel - problemas na validação de permissão"
      assert_not assinante.allow?("devise/registrations", "destroy"), "Profissional(assinante) - devise/registrations#destroy - problemas na validação de permissão"

      assert assinante.allow?("devise/professional_registrations", "create"), "Profissional(assinante) - devise/professional_registrations#create - problemas na validação de permissão"
      assert assinante.allow?("devise/professional_registrations", "new"), "Profissional(assinante) - devise/professional_registrations#new - problemas na validação de permissão"
      assert assinante.allow?("devise/professional_registrations", "edit"), "Profissional(assinante) - devise/professional_registrations#edit - problemas na validação de permissão"
      assert assinante.allow?("devise/professional_registrations", "update"), "Profissional(assinante) - devise/professional_registrations#update - problemas na validação de permissão"
      assert_not assinante.allow?("devise/professional_registrations", "cancel"), "Profissional(assinante) - devise/professional_registrations#cancel - problemas na validação de permissão"
      assert_not assinante.allow?("devise/professional_registrations", "destroy"), "Profissional(assinante) - devise/professional_registrations#destroy - problemas na validação de permissão"

      assert assinante.allow?("services", "new"), "Profissional(assinante) - services#new - problemas na validação de permissão"
      assert assinante.allow?("services", "update"), "Profissional(assinante) - services#update - problemas na validação de permissão"
      assert assinante.allow?("services", "index"), "Profissional(assinante) - services#index - problemas na validação de permissão"
      assert assinante.allow?("services", "create"), "Profissional(assinante) - services#create - problemas na validação de permissão"
      assert assinante.allow?("services", "edit"), "Profissional(assinante) - services#edit - problemas na validação de permissão"
      assert assinante.allow?("services", "show"), "Profissional(assinante) - services#show - problemas na validação de permissão"
      assert assinante.allow?("services", "destroy"), "Profissional(assinante) - services#destroy - problemas na validação de permissão"

      assert assinante.allow?("customers", "new"), "Profissional(assinante) - customers#new - problemas na validação de permissão"
      assert_not assinante.allow?("customers", "update"), "Profissional(assinante) - customers#update - problemas na validação de permissão"
      assert_not assinante.allow?("customers", "index"), "Profissional(assinante) - customers#index - problemas na validação de permissão"
      assert assinante.allow?("customers", "create"), "Profissional(assinante) - customers#create - problemas na validação de permissão"
      assert_not assinante.allow?("customers", "edit"), "Profissional(assinante) - customers#edit - problemas na validação de permissão"
      assert_not assinante.allow?("customers", "show"), "Profissional(assinante) - customers#show - problemas na validação de permissão"
      assert_not assinante.allow?("customers", "destroy"), "Profissional(assinante) - customers#destroy - problemas na validação de permissão"
      assert assinante.allow?("customers", "filter_by_email"), "Profissional(assinante) - customers#filter_by_email - problemas na validação de permissão"
      assert assinante.allow?("customers", "filter_by_telefone"), "Profissional(assinante) - customers#filter_by_telefone - problemas na validação de permissão"

      assert_not assinante.allow?("statuses", "new"), "Profissional(assinante) - statuses#new - problemas na validação de permissão"
      assert_not assinante.allow?("statuses", "update"), "Profissional(assinante) - statuses#update - problemas na validação de permissão"
      assert_not assinante.allow?("statuses", "index"), "Profissional(assinante) - statuses#index - problemas na validação de permissão"
      assert_not assinante.allow?("statuses", "create"), "Profissional(assinante) - statuses#create - problemas na validação de permissão"
      assert_not assinante.allow?("statuses", "edit"), "Profissional(assinante) - statuses#edit - problemas na validação de permissão"
      assert_not assinante.allow?("statuses", "show"), "Profissional(assinante) - statuses#show - problemas na validação de permissão"
      assert_not assinante.allow?("statuses", "destroy"), "Profissional(assinante) - statuses#destroy - problemas na validação de permissão"

      assert_not assinante.allow?("rewards", "new"), "Profissional(assinante) - rewards#new - problemas na validação de permissão"
      assert_not assinante.allow?("rewards", "update"), "Profissional(assinante) - rewards#update - problemas na validação de permissão"
      assert_not assinante.allow?("rewards", "index"), "Profissional(assinante) - rewards#index - problemas na validação de permissão"
      assert_not assinante.allow?("rewards", "create"), "Profissional(assinante) - rewards#create - problemas na validação de permissão"
      assert_not assinante.allow?("rewards", "edit"), "Profissional(assinante) - rewards#edit - problemas na validação de permissão"
      assert_not assinante.allow?("rewards", "show"), "Profissional(assinante) - rewards#show - problemas na validação de permissão"
      assert_not assinante.allow?("rewards", "destroy"), "Profissional(assinante) - rewards#destroy - problemas na validação de permissão"

      assert_not assinante.allow?("photo_logs", "create"), "Profissional(assinante) - photo_logs#create - problemas na validação de permissão"
      assert_not assinante.allow?("photo_logs", "new"), "Profissional(assinante) - photo_logs#new - problemas na validação de permissão"
      assert_not assinante.allow?("photo_logs", "update"), "Profissional(assinante) - photo_logs#update - problemas na validação de permissão"
      assert_not assinante.allow?("photo_logs", "index"), "Profissional(assinante) - photo_logs#index - problemas na validação de permissão"
      assert_not assinante.allow?("photo_logs", "edit"), "Profissional(assinante) - photo_logs#edit - problemas na validação de permissão"
      assert_not assinante.allow?("photo_logs", "show"), "Profissional(assinante) - photo_logs#show - problemas na validação de permissão"
      assert_not assinante.allow?("photo_logs", "destroy"), "Profissional(assinante) - photo_logs#destroy - problemas na validação de permissão"
      assert_not assinante.allow?("photo_logs", "send_to_fb"), "Profissional(assinante) - photo_logs#send_to_fb - problemas na validação de permissão"

      assert_not assinante.allow?("order_statuses", "new"), "Profissional(assinante) - order_statuses#new - problemas na validação de permissão"
      assert_not assinante.allow?("order_statuses", "update"), "Profissional(assinante) - order_statuses#update - problemas na validação de permissão"
      assert_not assinante.allow?("order_statuses", "index"), "Profissional(assinante) - order_statuses#index - problemas na validação de permissão"
      assert_not assinante.allow?("order_statuses", "create"), "Profissional(assinante) - order_statuses#create - problemas na validação de permissão"
      assert_not assinante.allow?("order_statuses", "edit"), "Profissional(assinante) - order_statuses#edit - problemas na validação de permissão"
      assert_not assinante.allow?("order_statuses", "show"), "Profissional(assinante) - order_statuses#show - problemas na validação de permissão"
      assert_not assinante.allow?("order_statuses", "destroy"), "Profissional(assinante) - order_statuses#destroy - problemas na validação de permissão"

      assert_not assinante.allow?("professionals", "new"), "Profissional(assinante) - professionals#new - problemas na validação de permissão"
      assert_not assinante.allow?("professionals", "update"), "Profissional(assinante) - professionals#update - problemas na validação de permissão"
      assert_not assinante.allow?("professionals", "index"), "Profissional(assinante) - professionals#index - problemas na validação de permissão"
      assert_not assinante.allow?("professionals", "create"), "Profissional(assinante) - professionals#create - problemas na validação de permissão"
      assert_not assinante.allow?("professionals", "edit"), "Profissional(assinante) - professionals#edit - problemas na validação de permissão"
      assert_not assinante.allow?("professionals", "show"), "Profissional(assinante) - professionals#show - problemas na validação de permissão"
      assert_not assinante.allow?("professionals", "destroy"), "Profissional(assinante) - professionals#destroy - problemas na validação de permissão"
    end
  end

  describe "Customers" do
    let(:customer) {Permission.new(customers(:cristiano))}

    test "Customer" do
      assert_not customer.allow?("dashboard", "index"), "Customer - dashboard#index - problemas na validação de permissão"
      assert_not customer.allow?("dashboard", "taken_steps"), "Customer - dashboard#taken_steps - problemas na validação de permissão"

      assert customer.allow?("static_pages", "privacy"), "Customer - static_pages#privacy - problemas na validação de permissão"

      assert customer.allow?("notifications", "new"), "Customer - notifications#new - problemas na validação de permissão"
      assert customer.allow?("notifications", "retorno_pagamento"), "Customer - notifications#retorno_pagamento - problemas na validação de permissão"

      assert_not customer.allow?("rewards", "get_customer_rewards"), "Customer - rewards#get_customer_rewards - problemas na validação de permissão"

      assert customer.allow?("photo_logs", "create"), "Customer - photo_logs#create - problemas na validação de permissão"
      assert customer.allow?("photo_logs", "new"), "Customer - photo_logs#new - problemas na validação de permissão"
      assert_not customer.allow?("photo_logs", "update"), "Customer - photo_logs#update - problemas na validação de permissão"
      assert customer.allow?("photo_logs", "index"), "Customer - photo_logs#index - problemas na validação de permissão"
      assert_not customer.allow?("photo_logs", "edit"), "Customer - photo_logs#edit - problemas na validação de permissão"
      assert_not customer.allow?("photo_logs", "show"), "Customer - photo_logs#show - problemas na validação de permissão"
      assert customer.allow?("photo_logs", "destroy"), "Customer - photo_logs#destroy - problemas na validação de permissão"
      assert customer.allow?("photo_logs", "send_to_fb"), "Customer - photo_logs#send_to_fb - problemas na validação de permissão"

      assert_not customer.allow?("devise/sessions", "new"), "Customer - devise/sessions#new - problemas na validação de permissão"
      assert_not customer.allow?("devise/sessions", "create"), "Customer - devise/sessions#create - problemas na validação de permissão"
      assert_not customer.allow?("devise/sessions", "destroy"), "Customer - devise/sessions#destroy - problemas na validação de permissão"

      assert customer.allow?("sessions", "new"), "Customer - sessions#new - problemas na validação de permissão"
      assert customer.allow?("sessions", "create"), "Customer - sessions#create - problemas na validação de permissão"
      assert customer.allow?("sessions", "destroy"), "Customer - sessions#destroy - problemas na validação de permissão"
      assert customer.allow?("customer_omniauth_callbacks", "facebook"), "Customer - customer_omniauth_callbacks#facebook - problemas na validação de permissão"

      assert customer.allow?("devise/passwords", "new"), "Customer - devise/passwords#new - problemas na validação de permissão"
      assert customer.allow?("devise/passwords", "update"), "Customer - devise/passwords#update - problemas na validação de permissão"
      assert customer.allow?("devise/passwords", "create"), "Customer - devise/passwords#create - problemas na validação de permissão"
      assert customer.allow?("devise/passwords", "edit"), "Customer - devise/passwords#edit - problemas na validação de permissão"

      assert customer.allow?("devise/confirmations", "new"), "Customer - devise/confirmations#new - problemas na validação de permissão"
      assert customer.allow?("devise/confirmations", "create"), "Customer - devise/confirmations#create - problemas na validação de permissão"
      assert customer.allow?("devise/confirmations", "show"), "Customer - devise/confirmations#show - problemas na validação de permissão"

      assert_not customer.allow?("devise/registrations", "create"), "Customer - devise/registrations#create - problemas na validação de permissão"
      assert_not customer.allow?("devise/registrations", "new"), "Customer - devise/registrations#new - problemas na validação de permissão"
      assert_not customer.allow?("devise/registrations", "edit"), "Customer - devise/registrations#edit - problemas na validação de permissão"
      assert_not customer.allow?("devise/registrations", "update"), "Customer - devise/registrations#update - problemas na validação de permissão"
      assert_not customer.allow?("devise/registrations", "cancel"), "Customer - devise/registrations#cancel - problemas na validação de permissão"
      assert_not customer.allow?("devise/registrations", "destroy"), "Customer - devise/registrations#destroy - problemas na validação de permissão"

      assert customer.allow?("devise/professional_registrations", "create"), "Customer - devise/professional_registrations#create - problemas na validação de permissão"
      assert customer.allow?("devise/professional_registrations", "new"), "Customer - devise/professional_registrations#new - problemas na validação de permissão"
      assert_not customer.allow?("devise/professional_registrations", "edit"), "Customer - devise/professional_registrations#edit - problemas na validação de permissão"
      assert_not customer.allow?("devise/professional_registrations", "update"), "Customer - devise/professional_registrations#update - problemas na validação de permissão"
      assert_not customer.allow?("devise/professional_registrations", "cancel"), "Customer - devise/professional_registrations#cancel - problemas na validação de permissão"
      assert_not customer.allow?("devise/professional_registrations", "destroy"), "Customer - devise/professional_registrations#destroy - problemas na validação de permissão"

      assert_not customer.allow?("schedules", "new"), "Customer - schedules#new - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "update"), "Customer - schedules#update - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "index"), "Customer - schedules#index - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "create"), "Customer - schedules#create - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "edit"), "Customer - schedules#edit - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "show"), "Customer - schedules#show - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "destroy"), "Customer - schedules#destroy - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "new_exchange_order"), "Customer - schedules#new_exchange_order - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "create_exchange_order"), "Customer - schedules#create_exchange_order - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "get_last_two_months_scheduled_customers"), "Customer - schedules#get_last_two_months_scheduled_customers - problemas na validação de permissão"
      assert_not customer.allow?("schedules", "accept_exchange_order"), "Customer - schedules#accept_exchange_order - problemas na validação de permissão"
      assert customer.allow?("schedules", "meus_servicos_por_profissionais"), "Customer - schedules#meus_servicos_por_profissionais - problemas na validação de permissão"

      assert_not customer.allow?("services", "new"), "Customer - services#new - problemas na validação de permissão"
      assert_not customer.allow?("services", "update"), "Customer - services#update - problemas na validação de permissão"
      assert_not customer.allow?("services", "index"), "Customer - services#index - problemas na validação de permissão"
      assert_not customer.allow?("services", "create"), "Customer - services#create - problemas na validação de permissão"
      assert_not customer.allow?("services", "edit"), "Customer - services#edit - problemas na validação de permissão"
      assert_not customer.allow?("services", "show"), "Customer - services#show - problemas na validação de permissão"
      assert_not customer.allow?("services", "destroy"), "Customer - services#destroy - problemas na validação de permissão"

      assert customer.allow?("customers", "new"), "Customer - customers#new - problemas na validação de permissão"
      assert_not customer.allow?("customers", "update"), "Customer - customers#update - problemas na validação de permissão"
      assert_not customer.allow?("customers", "index"), "Customer - customers#index - problemas na validação de permissão"
      assert customer.allow?("customers", "create"), "Customer - customers#create - problemas na validação de permissão"
      assert_not customer.allow?("customers", "edit"), "Customer - customers#edit - problemas na validação de permissão"
      assert_not customer.allow?("customers", "show"), "Customer - customers#show - problemas na validação de permissão"
      assert_not customer.allow?("customers", "destroy"), "Customer - customers#destroy - problemas na validação de permissão"
      assert_not customer.allow?("customers", "filter_by_email"), "Customer - customers#filter_by_email - problemas na validação de permissão"
      assert_not customer.allow?("customers", "filter_by_telefone"), "Customer - customers#filter_by_telefone - problemas na validação de permissão"

      assert_not customer.allow?("statuses", "new"), "Customer - statuses#new - problemas na validação de permissão"
      assert_not customer.allow?("statuses", "update"), "Customer - statuses#update - problemas na validação de permissão"
      assert_not customer.allow?("statuses", "index"), "Customer - statuses#index - problemas na validação de permissão"
      assert_not customer.allow?("statuses", "create"), "Customer - statuses#create - problemas na validação de permissão"
      assert_not customer.allow?("statuses", "edit"), "Customer - statuses#edit - problemas na validação de permissão"
      assert_not customer.allow?("statuses", "show"), "Customer - statuses#show - problemas na validação de permissão"
      assert_not customer.allow?("statuses", "destroy"), "Customer - statuses#destroy - problemas na validação de permissão"

      assert_not customer.allow?("rewards", "new"), "Customer - rewards#new - problemas na validação de permissão"
      assert_not customer.allow?("rewards", "update"), "Customer - rewards#update - problemas na validação de permissão"
      assert_not customer.allow?("rewards", "index"), "Customer - rewards#index - problemas na validação de permissão"
      assert_not customer.allow?("rewards", "create"), "Customer - rewards#create - problemas na validação de permissão"
      assert_not customer.allow?("rewards", "edit"), "Customer - rewards#edit - problemas na validação de permissão"
      assert_not customer.allow?("rewards", "show"), "Customer - rewards#show - problemas na validação de permissão"
      assert_not customer.allow?("rewards", "destroy"), "Customer - rewards#destroy - problemas na validação de permissão"

      assert_not customer.allow?("order_statuses", "new"), "Customer - order_statuses#new - problemas na validação de permissão"
      assert_not customer.allow?("order_statuses", "update"), "Customer - order_statuses#update - problemas na validação de permissão"
      assert_not customer.allow?("order_statuses", "index"), "Customer - order_statuses#index - problemas na validação de permissão"
      assert_not customer.allow?("order_statuses", "create"), "Customer - order_statuses#create - problemas na validação de permissão"
      assert_not customer.allow?("order_statuses", "edit"), "Customer - order_statuses#edit - problemas na validação de permissão"
      assert_not customer.allow?("order_statuses", "show"), "Customer - order_statuses#show - problemas na validação de permissão"
      assert_not customer.allow?("order_statuses", "destroy"), "Customer - order_statuses#destroy - problemas na validação de permissão"

      assert_not customer.allow?("professionals", "new"), "Customer - professionals#new - problemas na validação de permissão"
      assert_not customer.allow?("professionals", "update"), "Customer - professionals#update - problemas na validação de permissão"
      assert_not customer.allow?("professionals", "index"), "Customer - professionals#index - problemas na validação de permissão"
      assert_not customer.allow?("professionals", "create"), "Customer - professionals#create - problemas na validação de permissão"
      assert_not customer.allow?("professionals", "edit"), "Customer - professionals#edit - problemas na validação de permissão"
      assert_not customer.allow?("professionals", "show"), "Customer - professionals#show - problemas na validação de permissão"
      assert_not customer.allow?("professionals", "destroy"), "Customer - professionals#destroy - problemas na validação de permissão"
    end

  end

  describe "Admin" do
    let(:admin)     { Permission.new(admins(:one)) }

    test "admin" do
      assert admin.allow?("dashboard", "taken_steps"), "Admin - dashboard#taken_steps - problemas na validação de permissão"
      assert admin.allow?("dashboard", "index"), "Admin - dashboard#index - problemas na validação de permissão"
      assert_not admin.allow?("devise/sessions", "new"), "Admin - devise/sessions#new - problemas na validação de permissão"
      assert admin.allow?("devise/sessions", "create"), "Admin - devise/sessions#create - problemas na validação de permissão"
      assert admin.allow?("devise/sessions", "destroy"), "Admin - devise/sessions#destroy - problemas na validação de permissão"
    end
  end
end