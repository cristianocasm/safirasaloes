class CustomerMailer < ActionMailer::Base
  default from: "contato@safirasaloes.com.br"

  def invite_customer(profNome, datahora_inicio, ctEmail, token, serviceNome)
    @profNome = profNome
    @datahora_inicio = datahora_inicio
    @ctEmail = ctEmail
    @token = token
    @serviceNome = serviceNome
    mail to: @ctEmail, subject: "Uma surpresa aguarda você no #{@profNome}"
  end

  def notify_customer(id)
    @schedule = Schedule.find_by_id(id)
    if @schedule.present?
      mail to: @schedule.email, subject: "Quer ganhar mais recompensas?!? - #{@schedule.professional.nome}"
    end
  end
end
