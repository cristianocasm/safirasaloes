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
    let(:suspenso) { Permission.new(professionals(:prof_suspenso)) }
    let(:assinante) { Permission.new(professionals(:prof_assinante)) }

    test "deslogado" do
      assert_not deslogado.allow?("schedules", "new")
      assert_not deslogado.allow?("schedules", "update")
      assert_not deslogado.allow?("schedules", "index")
      assert_not deslogado.allow?("schedules", "create")
      assert_not deslogado.allow?("schedules", "edit")
      assert_not deslogado.allow?("schedules", "show")
      assert_not deslogado.allow?("schedules", "destroy")
      assert_not deslogado.allow?("schedules", "get_last_two_months_served_customers")

      assert deslogado.allow?("devise/sessions", "new")
      assert deslogado.allow?("devise/sessions", "create")
      assert deslogado.allow?("devise/sessions", "destroy")

      assert deslogado.allow?("devise/passwords", "new")
      assert deslogado.allow?("devise/passwords", "update")
      assert deslogado.allow?("devise/passwords", "create")
      assert deslogado.allow?("devise/passwords", "edit")

      assert deslogado.allow?("devise/confirmations", "new")
      assert deslogado.allow?("devise/confirmations", "create")
      assert deslogado.allow?("devise/confirmations", "show")

      assert deslogado.allow?("devise/registrations", "create")
      assert deslogado.allow?("devise/registrations", "new")
      assert deslogado.allow?("devise/registrations", "edit")
      assert deslogado.allow?("devise/registrations", "update")
      assert_not deslogado.allow?("devise/registrations", "cancel")
      assert_not deslogado.allow?("devise/registrations", "destroy")

      assert_not deslogado.allow?("services", "new")
      assert_not deslogado.allow?("services", "update")
      assert_not deslogado.allow?("services", "index")
      assert_not deslogado.allow?("services", "create")
      assert_not deslogado.allow?("services", "edit")
      assert_not deslogado.allow?("services", "show")
      assert_not deslogado.allow?("services", "destroy")

      assert_not deslogado.allow?("customers", "new")
      assert_not deslogado.allow?("customers", "update")
      assert_not deslogado.allow?("customers", "index")
      assert_not deslogado.allow?("customers", "create")
      assert_not deslogado.allow?("customers", "edit")
      assert_not deslogado.allow?("customers", "show")
      assert_not deslogado.allow?("customers", "destroy")

      assert_not deslogado.allow?("statuses", "new")
      assert_not deslogado.allow?("statuses", "update")
      assert_not deslogado.allow?("statuses", "index")
      assert_not deslogado.allow?("statuses", "create")
      assert_not deslogado.allow?("statuses", "edit")
      assert_not deslogado.allow?("statuses", "show")
      assert_not deslogado.allow?("statuses", "destroy")
    end

    test "testando" do
      assert _testando.allow?("schedules", "new")
      assert _testando.allow?("schedules", "update")
      assert _testando.allow?("schedules", "index")
      assert _testando.allow?("schedules", "create")
      assert _testando.allow?("schedules", "edit")
      assert _testando.allow?("schedules", "show")
      assert _testando.allow?("schedules", "destroy")
      assert _testando.allow?("schedules", "get_last_two_months_served_customers")

      assert _testando.allow?("devise/sessions", "new")
      assert _testando.allow?("devise/sessions", "create")
      assert _testando.allow?("devise/sessions", "destroy")

      assert _testando.allow?("devise/passwords", "new")
      assert _testando.allow?("devise/passwords", "update")
      assert _testando.allow?("devise/passwords", "create")
      assert _testando.allow?("devise/passwords", "edit")

      assert _testando.allow?("devise/confirmations", "new")
      assert _testando.allow?("devise/confirmations", "create")
      assert _testando.allow?("devise/confirmations", "show")

      assert _testando.allow?("devise/registrations", "create")
      assert _testando.allow?("devise/registrations", "new")
      assert _testando.allow?("devise/registrations", "edit")
      assert _testando.allow?("devise/registrations", "update")
      assert_not _testando.allow?("devise/registrations", "cancel")
      assert_not _testando.allow?("devise/registrations", "destroy")

      assert _testando.allow?("services", "new")
      assert _testando.allow?("services", "update")
      assert _testando.allow?("services", "index")
      assert _testando.allow?("services", "create")
      assert _testando.allow?("services", "edit")
      assert _testando.allow?("services", "show")
      assert _testando.allow?("services", "destroy")

      assert_not _testando.allow?("customers", "new")
      assert_not _testando.allow?("customers", "update")
      assert_not _testando.allow?("customers", "index")
      assert_not _testando.allow?("customers", "create")
      assert_not _testando.allow?("customers", "edit")
      assert_not _testando.allow?("customers", "show")
      assert_not _testando.allow?("customers", "destroy")

      assert_not _testando.allow?("statuses", "new")
      assert_not _testando.allow?("statuses", "update")
      assert_not _testando.allow?("statuses", "index")
      assert_not _testando.allow?("statuses", "create")
      assert_not _testando.allow?("statuses", "edit")
      assert_not _testando.allow?("statuses", "show")
      assert_not _testando.allow?("statuses", "destroy")
    end

    test "bloqueado" do
      assert bloqueado.allow?("schedules", "new")
      assert bloqueado.allow?("schedules", "index")
      assert_not bloqueado.allow?("schedules", "update")
      assert_not bloqueado.allow?("schedules", "create")
      assert_not bloqueado.allow?("schedules", "edit")
      assert_not bloqueado.allow?("schedules", "show")
      assert_not bloqueado.allow?("schedules", "destroy")
      assert_not bloqueado.allow?("schedules", "get_last_two_months_served_customers")

      assert bloqueado.allow?("devise/sessions", "new")
      assert bloqueado.allow?("devise/sessions", "create")
      assert bloqueado.allow?("devise/sessions", "destroy")

      assert bloqueado.allow?("devise/passwords", "new")
      assert bloqueado.allow?("devise/passwords", "update")
      assert bloqueado.allow?("devise/passwords", "create")
      assert bloqueado.allow?("devise/passwords", "edit")

      assert bloqueado.allow?("devise/confirmations", "new")
      assert bloqueado.allow?("devise/confirmations", "create")
      assert bloqueado.allow?("devise/confirmations", "show")

      assert_not bloqueado.allow?("devise/registrations", "create")
      assert_not bloqueado.allow?("devise/registrations", "new")
      assert_not bloqueado.allow?("devise/registrations", "edit")
      assert_not bloqueado.allow?("devise/registrations", "update")
      assert_not bloqueado.allow?("devise/registrations", "cancel")
      assert_not bloqueado.allow?("devise/registrations", "destroy")

      assert_not bloqueado.allow?("services", "new")
      assert_not bloqueado.allow?("services", "update")
      assert_not bloqueado.allow?("services", "index")
      assert_not bloqueado.allow?("services", "create")
      assert_not bloqueado.allow?("services", "edit")
      assert_not bloqueado.allow?("services", "show")
      assert_not bloqueado.allow?("services", "destroy")

      assert_not bloqueado.allow?("customers", "new")
      assert_not bloqueado.allow?("customers", "update")
      assert_not bloqueado.allow?("customers", "index")
      assert_not bloqueado.allow?("customers", "create")
      assert_not bloqueado.allow?("customers", "edit")
      assert_not bloqueado.allow?("customers", "show")
      assert_not bloqueado.allow?("customers", "destroy")

      assert_not bloqueado.allow?("statuses", "new")
      assert_not bloqueado.allow?("statuses", "update")
      assert_not bloqueado.allow?("statuses", "index")
      assert_not bloqueado.allow?("statuses", "create")
      assert_not bloqueado.allow?("statuses", "edit")
      assert_not bloqueado.allow?("statuses", "show")
      assert_not bloqueado.allow?("statuses", "destroy")
    end

    test "suspenso" do
      assert suspenso.allow?("schedules", "new")
      assert_not suspenso.allow?("schedules", "destroy")
      assert_not suspenso.allow?("schedules", "update")
      assert_not suspenso.allow?("schedules", "index")
      assert_not suspenso.allow?("schedules", "create")
      assert_not suspenso.allow?("schedules", "edit")
      assert_not suspenso.allow?("schedules", "show")
      assert_not suspenso.allow?("schedules", "get_last_two_months_served_customers")

      assert suspenso.allow?("devise/sessions", "new")
      assert suspenso.allow?("devise/sessions", "create")
      assert suspenso.allow?("devise/sessions", "destroy")

      assert suspenso.allow?("devise/passwords", "new")
      assert suspenso.allow?("devise/passwords", "update")
      assert suspenso.allow?("devise/passwords", "create")
      assert suspenso.allow?("devise/passwords", "edit")

      assert suspenso.allow?("devise/confirmations", "new")
      assert suspenso.allow?("devise/confirmations", "create")
      assert suspenso.allow?("devise/confirmations", "show")

      assert_not suspenso.allow?("devise/registrations", "create")
      assert_not suspenso.allow?("devise/registrations", "new")
      assert_not suspenso.allow?("devise/registrations", "edit")
      assert_not suspenso.allow?("devise/registrations", "update")
      assert_not suspenso.allow?("devise/registrations", "cancel")
      assert_not suspenso.allow?("devise/registrations", "destroy")

      assert_not suspenso.allow?("services", "new")
      assert_not suspenso.allow?("services", "update")
      assert_not suspenso.allow?("services", "index")
      assert_not suspenso.allow?("services", "create")
      assert_not suspenso.allow?("services", "edit")
      assert_not suspenso.allow?("services", "show")
      assert_not suspenso.allow?("services", "destroy")

      assert_not suspenso.allow?("customers", "new")
      assert_not suspenso.allow?("customers", "update")
      assert_not suspenso.allow?("customers", "index")
      assert_not suspenso.allow?("customers", "create")
      assert_not suspenso.allow?("customers", "edit")
      assert_not suspenso.allow?("customers", "show")
      assert_not suspenso.allow?("customers", "destroy")

      assert_not suspenso.allow?("statuses", "new")
      assert_not suspenso.allow?("statuses", "update")
      assert_not suspenso.allow?("statuses", "index")
      assert_not suspenso.allow?("statuses", "create")
      assert_not suspenso.allow?("statuses", "edit")
      assert_not suspenso.allow?("statuses", "show")
      assert_not suspenso.allow?("statuses", "destroy")
    end

    test "assinante" do
      assert assinante.allow?("schedules", "new")
      assert assinante.allow?("schedules", "update")
      assert assinante.allow?("schedules", "index")
      assert assinante.allow?("schedules", "create")
      assert assinante.allow?("schedules", "edit")
      assert assinante.allow?("schedules", "show")
      assert assinante.allow?("schedules", "destroy")

      assert assinante.allow?("devise/sessions", "new")
      assert assinante.allow?("devise/sessions", "create")
      assert assinante.allow?("devise/sessions", "destroy")

      assert assinante.allow?("devise/passwords", "new")
      assert assinante.allow?("devise/passwords", "update")
      assert assinante.allow?("devise/passwords", "create")
      assert assinante.allow?("devise/passwords", "edit")

      assert assinante.allow?("devise/confirmations", "new")
      assert assinante.allow?("devise/confirmations", "create")
      assert assinante.allow?("devise/confirmations", "show")

      assert assinante.allow?("devise/registrations", "create")
      assert assinante.allow?("devise/registrations", "new")
      assert assinante.allow?("devise/registrations", "edit")
      assert assinante.allow?("devise/registrations", "update")
      assert_not assinante.allow?("devise/registrations", "cancel")
      assert_not assinante.allow?("devise/registrations", "destroy")

      assert assinante.allow?("services", "new")
      assert assinante.allow?("services", "update")
      assert assinante.allow?("services", "index")
      assert assinante.allow?("services", "create")
      assert assinante.allow?("services", "edit")
      assert assinante.allow?("services", "show")
      assert assinante.allow?("services", "destroy")

      assert_not assinante.allow?("customers", "new")
      assert_not assinante.allow?("customers", "update")
      assert_not assinante.allow?("customers", "index")
      assert_not assinante.allow?("customers", "create")
      assert_not assinante.allow?("customers", "edit")
      assert_not assinante.allow?("customers", "show")
      assert_not assinante.allow?("customers", "destroy")

      assert_not assinante.allow?("statuses", "new")
      assert_not assinante.allow?("statuses", "update")
      assert_not assinante.allow?("statuses", "index")
      assert_not assinante.allow?("statuses", "create")
      assert_not assinante.allow?("statuses", "edit")
      assert_not assinante.allow?("statuses", "show")
      assert_not assinante.allow?("statuses", "destroy")
    end
  end
end