class NotificationsController < ApplicationController
  require 'open-uri'

  skip_before_filter :verify_authenticity_token, only: [:new]

  STATUS_NAME = {
                  '1' => 'Aguardando pagamento',
                  '2' => 'Em análise',
                  '3' => 'Paga',
                  '4' => 'Disponível',
                  '5' => 'Em disputa',
                  '6' => 'Devolvida',
                  '7' => 'Cancelada',
                  '8' => 'Chargeback debitado',
                  '9' => 'Em contestação'
                }.freeze

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
    transacao = params[:transacao]

    if transacao.present?
      response = request_full_transaction_from_pagseguro(transacao)

      if transaction_found?(response)
        @status = STATUS_NAME[Nokogiri::XML(response.body).xpath('//transaction/status').text]
        @valor = Nokogiri::XML(response.body).xpath('//grossAmount').text
        @code = Nokogiri::XML(response.body).xpath('//code').text
        current_professional.update_attribute(:transacao_pagseguro, transacao) if current_professional.present?
        render layout: false and return
      end
    end
    
    redirect_to root_url, flash: { error: "Não autorizado." }
  end

  private

  def request_full_transaction_from_pagseguro(transacao)
    domain = "https://ws.pagseguro.uol.com.br"
    email = ENV['PAGSEGURO_EMAIL']
    token = ENV['PAGSEGURO_TOKEN']
    path = "/v3/transactions/#{transacao}?email=#{email}&token=#{token}"
    Net::HTTP.get_response(URI("#{domain}#{path}"))
  end

  def transaction_found?(response)
    response.header.code == "200"
  end

end