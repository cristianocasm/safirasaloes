class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:new]


  # POST /profissional/notificacao
  def new
    transac = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])

    if transac.errors.empty?
      PagseguroWorker.perform_async(transac.code, transac.status.id)
    end

    render nothing: true, status: 200
  end

  # GET /profissional/retorno-pagamento?transacao="CHARACTERS_SEQUENCE"
  def retorno_pagamento
    if params[:transacao].present?
      current_professional.update_attribute(:transacao_pagseguro, params[:transacao])
      redirect_to professional_root_url, flash: { success: "Obrigado. Recebemos seu pedido e seu acesso será liberado assim que o pagamento for confirmado." }
    else
      redirect_to professional_root_url, flash: { error: "Não autorizado." }
    end
  end
end