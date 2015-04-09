class GetLastScheduleWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  # Necessário para que Customer seja capaz de
  # acessar 'meus_serviços' logo após o cadastro
  # e visualizar os serviços fornecidos pelo
  # profissional que o convidou.
  def perform(ctEmail, ctId)
    sc = Schedule.
          where('email = ?', ctEmail).
          order('created_at DESC').
          first
    ct = Customer.find(ctId)
    
    sc.update_attribute(:customer_id, ctId)
    ct.update_attribute(:schedule_recovered, true)
  end
end