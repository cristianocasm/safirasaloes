class PagseguroWorker
  include Sidekiq::Worker

  sidekiq_options retry: true

  # Atualiza status e vigência de profissional
  # @code - código da transação no PagSeguro
  # @status - status da transação no PagSeguro
  def perform(code, status)
    newProfesStatus = get_new_status(status)
    
    if newProfesStatus.present?
      pr = Professional.find_by_transacao_pagseguro(code)
      pr.update_attributes(
        status_id: newProfesStatus.id,
        data_expiracao_status: Time.zone.now + newProfesStatus.dias_vigencia.days
      )
    end
  end

  private

  # Baseado na máquina de estados definida em
  # https://pagseguro.uol.com.br/v3/guia-de-integracao/api-de-notificacoes.html
  def get_new_status(status)
    case status.to_i
    when 3..4 # Paga
      Status.find_by_nome('assinante')
    when 6..8 
      Status.find_by_nome('suspenso')
    end
  end
end