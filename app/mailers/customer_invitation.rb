class CustomerInvitation < ActionMailer::Base
  default from: "contato@safirasaloes.com.br"

  def invite_customer(id)
    @schedule = Schedule.find_by_id(id)
    mail to: @schedule.email, subject: "Uma surpresa está aguardando por você no #{@schedule.professional.nome}"
  end

  def notify_customer(id)
    @schedule = Schedule.find_by_id(id)
    mail to: @schedule.email, subject: "Quer ganhar mais recompensas?!? - #{@schedule.professional.nome}"
  end
end
