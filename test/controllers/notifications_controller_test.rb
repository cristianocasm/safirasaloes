class NotificationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  STATUS = {
    aguardando: 1,
    analise: 2,
    paga: 3,
    disponivel: 4,
    disputa: 5,
    devolvida: 6,
    cancelada: 7,
    chargeBack: 8,
    contestacao: 9
  }

  context "recebimento de notificações" do
    
    setup do
      @pr = professionals(:aline)
      @pr.update_attributes(status_id: nil)
    end

    should "não altera status do profissional - transação Aguardando Pagamento" do
      get_notification_by STATUS[:aguardando]
      assert_nil @pr.status_id
      assert_equal @pr.status_id, Professional.find(@pr.id).status_id
      assert_equal @pr.data_expiracao_status, Professional.find(@pr.id).data_expiracao_status
    end

    should "não altera status do profissional - transação Em Análise" do
      get_notification_by STATUS[:analise]
      assert_nil @pr.status_id
      assert_equal @pr.status_id, Professional.find(@pr.id).status_id
      assert_equal @pr.data_expiracao_status, Professional.find(@pr.id).data_expiracao_status
    end

    should "altera status do profissional para assinante - transação Paga" do
      get_notification_by STATUS[:paga]
      st = statuses(:assinante)
      assert_nil @pr.status_id
      assert_equal st, Professional.find(@pr.id).status
      assert_equal (Time.zone.now + st.dias_vigencia.days).to_date, Professional.find(@pr.id).data_expiracao_status.to_date
    end

    should "altera status do profissional para assinante - transação Disponível" do
      get_notification_by STATUS[:disponivel]
      st = statuses(:assinante)
      assert_nil @pr.status_id
      assert_equal st, Professional.find(@pr.id).status
      assert_equal (Time.zone.now + st.dias_vigencia.days).to_date, Professional.find(@pr.id).data_expiracao_status.to_date
    end

    should "não altera status do profissional - transação Em Disputa" do
      get_notification_by STATUS[:disputa]
      assert_nil @pr.status_id
      assert_equal @pr.status_id, Professional.find(@pr.id).status_id
      assert_equal @pr.data_expiracao_status, Professional.find(@pr.id).data_expiracao_status
    end

    should "altera status do profissional para suspenso - transação Devolvida" do
      get_notification_by STATUS[:devolvida]
      st = statuses(:suspenso)
      assert_nil @pr.status_id
      assert_equal st, Professional.find(@pr.id).status
      assert_equal (Time.zone.now + st.dias_vigencia.days).to_date, Professional.find(@pr.id).data_expiracao_status.to_date
    end

    should "altera status do profissional para suspenso - transação Cancelada" do
      get_notification_by STATUS[:cancelada]
      st = statuses(:suspenso)
      assert_nil @pr.status_id
      assert_equal st, Professional.find(@pr.id).status
      assert_equal (Time.zone.now + st.dias_vigencia.days).to_date, Professional.find(@pr.id).data_expiracao_status.to_date
    end

    should "altera status do profissional para suspenso - transação ChargeBack" do
      get_notification_by STATUS[:chargeBack]
      st = statuses(:suspenso)
      assert_nil @pr.status_id
      assert_equal st, Professional.find(@pr.id).status
      assert_equal (Time.zone.now + st.dias_vigencia.days).to_date, Professional.find(@pr.id).data_expiracao_status.to_date
    end

    should "não altera status do profissional - transação Em Contestação" do
      get_notification_by STATUS[:contestação]
      assert_nil @pr.status_id
      assert_equal @pr.status_id, Professional.find(@pr.id).status_id
      assert_equal @pr.data_expiracao_status, Professional.find(@pr.id).data_expiracao_status
    end
  end

  context "redirecionamento de pagamento" do
    setup do
      @professional = professionals(:joao)
      sign_in :professional, @professional
    end

    should "atualizar parâmetro 'transacao_pagseguro' se parâmetro 'transacao' é enviado na requisição" do
      transacao = 'TEST-ABC123'
      get :retorno_pagamento, transacao: transacao

      assert_equal transacao, Professional.find(@professional.id).transacao_pagseguro
    end
    
    should "redirecionar para professional_root_path se parâmetro 'transacao' não é enviado na requisição" do
      get :retorno_pagamento

      assert_response :redirect
    end

  end

end

def get_notification_by(status)
  trans = transaction(status)
  PagSeguro::Transaction.stubs(:find_by_notification_code).returns(trans)
  post :new, { notificationCode: 'ABC-123' }
end

def transaction(status, code='ABC-123')
  PagSeguro::Transaction.new(code: code, status: status)
end