# == Schema Information
#
# Table name: schedules
#
#  id                   :integer          not null, primary key
#  professional_id      :integer
#  customer_id          :integer
#  datahora_inicio      :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  datahora_fim         :datetime
#  safiras_resgatadas   :integer          default(0)
#  nome                 :string(255)
#  email                :string(255)
#  telefone             :string(255)
#  pago_com_safiras     :boolean          default(FALSE)
#  recompensa_fornecida :boolean          default(FALSE)
#  price_id             :integer
#

class Schedule < ActiveRecord::Base
  belongs_to :professional
  belongs_to :customer
  belongs_to :price
  has_many :photo_logs

  validates_presence_of :professional_id, :price_id
  validate :presence_of_customer_info, on: [:create, :update]
  validate :email_format
  validates :datahora_inicio, date: true, presence: true, on: [:create, :update]
  validates :datahora_fim, date: true, date: { after: Proc.new { :datahora_inicio } }, on: [:create, :update]

  before_save :deal_with_safiras_acceptance, if: Proc.new { |sc| sc.pago_com_safiras_changed? }
  before_save -> { email.downcase! }, if: Proc.new { |sc| sc.email.present? }
  after_create :send_email_notification, if: Proc.new { |sc| sc.email.present? }
  after_update :send_email_notification, if: Proc.new { |sc| sc.email.present? && (sc.email_changed? || sc.price_id_changed? || sc.datahora_inicio_changed? || sc.datahora_fim_changed?) }

  scope :get_last_two_months_scheduled_customers, -> (prof_id) {
                                                                  select('DISTINCT(nome), customer_id AS id', :email, :telefone).
                                                                  where(professional_id: prof_id).
                                                                  where(datahora_inicio: 60.days.ago .. 7.days.ago)
                                                                }

  scope :not_more_than_12_hours_ago, -> {
                                          includes(:price, :professional).
                                          where(datahora_inicio: 12.hours.ago..Time.zone.now)
                                        }

  scope :in_the_future, -> { where("datahora_fim > ?", DateTime.now) }
  scope :safiras_resgatadas, -> { where("pago_com_safiras = true").sum(:safiras_resgatadas) }

  def get_rewards_by_customer_and_professional
    Reward.
      where(
        "professional_id = ? AND customer_id = ?",
        self.professional_id,
        self.customer_id
      ).try(:first)
  end

  private

  def deal_with_safiras_acceptance
    if self.pago_com_safiras
      update_customers_rewards do |rws, safiras|
        rws.total_safiras -= safiras
        self.safiras_resgatadas = safiras
      end
    else
      update_customers_rewards do |rws, safiras|
        rws.total_safiras += self.safiras_resgatadas
        self.safiras_resgatadas = 0
      end
    end
  end

  def update_customers_rewards(&block)
    rws = get_rewards_by_customer_and_professional
    if rws.present?
      safiras = self.price.preco * 2
      yield rws, safiras
      rws.save
    end
  end

  def presence_of_customer_info
    if(nome.blank? && email.blank? && telefone.blank?)
      self.errors.add(:base, "Informe Nome e/ou Email e/ou Telefone do cliente")
      return false
    end
    true
  end

  def email_format
    return true if self.email.blank?

    match = (self.email =~ /(.+)(@)(.+)(\.)(.+)/)
    if match.nil?
      self.errors.add(:email, "formato incorreto") 
      return false
    end
    true
  end

  # include ActionView::Helpers::TextHelper

  # Se e-mail estiver presente, então é necessário notificar cliente com o envio
  # de um e-mail. O e-mail será um convite para cadastro no sistema, caso não haja
  # cliente cadastrado com o dado e-mail. Por outro lado, ele será uma notificação
  # a respeito do horário marcado caso haja cliente cadastrado com o dado e-mail.
  # Perceba que o profissional poderá escolher o cliente errado (o que seta
  # customer_id na view) e, logo após, informar o e-mail correto sem clicar na opção
  # dada. Como consequência teríamos uma situação onde o cliente seria notificado, mas
  # não conseguiria desfrutar da recompensa, porque o sistema não teria conhecimento
  # do seu horário marcado (customer_id do schedule estaria nulo). Assim, atualizamos
  # o atributo customer_id caso haja alguma inconsistência entre o cliente encontrado
  # e o e-mail informado.
  def send_email_notification
    ct = Customer.find_by_email(self.email)
    ct.present? ? notify_customer(ct) : invite_customer
  end

  def notify_customer(ct)
    if ct.id != self.customer_id
      self.update_attribute(:customer_id, ct.id)
    else
      recompensa = self.price.recompensa_divulgacao
      safiras = ActionController::Base.helpers.pluralize(recompensa, 'Safira')
      
      NotificationWorker.
        perform_async(
                      self.email,
                      self.professional.nome,
                      self.price.nome,
                      self.datahora_inicio.strftime('%d/%m/%Y'),
                      self.datahora_inicio.strftime('%H:%M'),
                      safiras
                    )
    end
  end

  def invite_customer
    if self.email.present?
      ci = CustomerInvitation.create(email: self.email)
      regUrl = generate_registration_url(ci.token)
      InvitationWorker.perform_async(
                                      self.professional.id,
                                      self.professional.nome,
                                      self.datahora_inicio.strftime('%d/%m/%Y'),
                                      self.datahora_inicio.strftime('%H:%M'),
                                      self.email,
                                      self.price.nome,
                                      regUrl,
                                      self.id
                                    )
    end
  end

  def generate_registration_url(token)
    routes = Rails.application.routes.url_helpers
    routes.new_customer_registration_url(
              host: ENV["HOST_URL"],
              customer: { email: self.email, token: token }
            )
  end

end
