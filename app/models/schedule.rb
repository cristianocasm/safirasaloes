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
  CELLPHONE_REGEX = /\(\d{2}\) [9|8|7]\d{3,4}-\d{4}/

  attr_accessor :feedback_msg, :data_inicio, :hora_inicio, :data_fim, :hora_fim

  has_many :scheduled_msgs, dependent: :destroy
  has_many :photo_logs
  has_one :customer_invitation
  belongs_to :professional
  belongs_to :customer
  belongs_to :price, :inverse_of => :schedules
  accepts_nested_attributes_for :price

  validates_presence_of :professional, :telefone, :nome
  validates_presence_of :price, message: I18n.t('schedule.not_created.price.blank')
  validates_format_of :telefone, with: CELLPHONE_REGEX, message: I18n.t('schedule.not_created.celular.invalido'), unless: Proc.new { |sc| sc.telefone.blank? }
  validates :datahora_inicio, date: true, date: {after_or_equal_to: Proc.new { DateTime.now } }, presence: true, on: [:create, :update]
  validates :datahora_fim, date: true, date: { after: Proc.new { :datahora_inicio } }, on: [:create, :update]

  before_validation :mount_date
  before_save :deal_with_safiras_acceptance, if: Proc.new { |sc| sc.pago_com_safiras_changed? }
  before_destroy :cancel_scheduled_sms, if: Proc.new { |sc| sc.scheduled_msgs.present? }
  after_create :notify
  after_update :notify, if: Proc.new { |sc| sc.telefone_changed? || sc.price_id_changed? || sc.datahora_inicio_changed? || sc.datahora_fim_changed? }

  # scope :get_last_two_months_scheduled_customers, -> (prof_id) {
  #                                                                 select('DISTINCT(nome), customer_id AS id', :telefone).
  #                                                                 where(professional_id: prof_id).
  #                                                                 where(datahora_inicio: 60.days.ago .. 7.days.ago)
  #                                                               }

  scope :not_more_than_12_hours_ago, -> {
                                          includes(:price, :professional).
                                          where(datahora_inicio: 12.hours.ago..Time.zone.now)
                                        }

  scope :in_the_future, -> { where("datahora_fim > ?", DateTime.now) }
  scope :safiras_resgatadas, -> { where("pago_com_safiras = true").sum(:safiras_resgatadas) }

  def mount_date
    self.datahora_inicio = "#{data_inicio} #{hora_inicio}" if data_inicio.present?
    self.datahora_fim = "#{data_fim} #{hora_fim}" if data_fim.present?
  end

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

  def generate_registration_url(token)
    "http://safirasaloes.com.br/fotos?s=#{token}#{self.id}"
    # routes = Rails.application.routes.url_helpers
    # routes.new_customer_registration_url(
    #           host: ENV["HOST_URL"],
    #           t: token,
    #           s: self.id
    #         )
  end

  def generate_invitation(ct)
    unless ct.present?
      ci = CustomerInvitation.create(schedule_id: self.id)
      generate_registration_url(ci.token)
    end
  end

  def get_professional_cellphone
    pr = self.professional
    [pr.telefone, pr.whatsapp].find { |tel| CELLPHONE_REGEX =~ tel } || ''
  end

  def notify
    ct = Customer.find_by_telefone(self.telefone)
    self.update_columns(customer_id: ct.id) if ct && ct.id != self.customer_id
    cancel_scheduled_sms if self.scheduled_msgs.present?
    send_sms_notification(ct)
  end

  def cancel_scheduled_sms
    smsIds = self.scheduled_msgs.map(&:api_id).join(";")
    uri = "https://www.facilitamovel.com.br/api/deleteMsgAgendadasPorId.ft?user=_SMS_USER_&password=_SMS_PASSWORD_&ids=_SMS_IDS_"
    uri.gsub!(/_SMS_USER_/, ENV['SMS_USER'])
    uri.gsub!(/_SMS_PASSWORD_/, ENV['SMS_PASSWORD'])
    uri.gsub!(/_SMS_IDS_/, smsIds)
    Net::HTTP.get_response(URI(uri))
  end

  def send_sms_notification(ct)
    prTel = get_professional_cellphone

    options = {
      srvNome: self.price.service.nome,
      dataInicio: self.datahora_inicio.strftime('%d/%m/%Y'),
      horaInicio: self.datahora_inicio.strftime('%H:%M'),
      prNome: self.professional.nome,
      ctTel: self.telefone.gsub(/\D/, ''),
      prTel: prTel.gsub(/\D/, ''),
      regUrl: generate_invitation(ct)
    }

    send_sms_to(:customer, options)
    send_sms_to(:professional, options) if prTel.present?
  end

  def get_date_to_send_sms_for(name)
    smsScheduledForDateTime = if name == :remembering
      self.datahora_inicio - 3.hours
    elsif name == :divulgation
      self.datahora_inicio
    end

    day = smsScheduledForDateTime.strftime("%d")
    month = smsScheduledForDateTime.strftime("%m")
    year = smsScheduledForDateTime.strftime("%Y")
    hour = smsScheduledForDateTime.strftime("%H")
    minute = smsScheduledForDateTime.strftime("%M")

    { d: day, M: month, y: year, h: hour, m: minute }
  end

  def send_sms_to(name, options)
    confirmationSMSId = send_sms_confirmation_to(name, options)
    rememberingSMSId = send_sms_remembering_to(name, options)
    divulgationSMSId = send_sms_divulgation_to(name, options)

    generate_msg_for_feedback(confirmationSMSId, rememberingSMSId, divulgationSMSId)
  end

  def generate_msg_for_feedback(confirmationSMSId, rememberingSMSId, divulgationSMSId)
    msgScheduled = ""
    msgScheduled += case divulgationSMSId.body.match(/(\d);(\d+)/)[1].to_i
    when 1
      I18n.t('schedule.created.sms.login_error', action: 'agendar', sms_type: 'SMS para estimular divulgação')
    when 2
      I18n.t('schedule.created.sms.no_credits_error', action: 'agendar', sms_type: 'SMS para estimular divulgação')
    when 3
      I18n.t('schedule.created.sms.invalid_cellphone_error', action: 'agendar', sms_type: 'SMS para estimular divulgação')
    when 4
      I18n.t('schedule.created.sms.invalid_msg_error', action: 'agendar', sms_type: 'SMS para estimular divulgação')
    when 5, 6
      self.scheduled_msgs.create(api_id: divulgationSMSId.body.match(/(\d);(\d+)/)[2].to_i)
      link = if self.price.recompensa_divulgacao.zero?
        I18n.t('schedule.created.sms.divulgation.create_rewards', url: get_edit_url_for(self.price.service))
      end
      I18n.t('schedule.created.sms.divulgation.success', sms_content: @divulgation, sms_title: @divulgationTitle, link: link)
    end

    msgScheduled = "Cliente agendado com sucesso!<br/>Enquanto você estiver atendendo ele, <b>enviaremos instruções para o telefone dele</b> para que ele divulgue \"<b>#{self.price.nome}</b>\" #{msgScheduled}"

    self.feedback_msg = msgScheduled
  end

  def get_edit_url_for(srv)
    Rails.application.routes.url_helpers.edit_service_url(host: ENV["HOST_URL"], id: srv.id)
  end

  def send_sms_confirmation_to(name, options)
    @confirmationTitle = "SMS de confirmação"
    fire_to(name, options, :confirmation) { "Olá\n\nSeu horário para #{options[:srvNome]} foi marcado para #{options[:dataInicio]} às #{options[:horaInicio]}\n\n-#{options[:prNome]}" }
  end

  def send_sms_remembering_to(name, options)
    @rememberingTitle = "SMS lembrete (programado para #{ ( self.datahora_inicio - 3.hours).strftime('%d/%m/%Y às %H:%M') })"

    content = "Não esqueça seu horário hoje às #{options[:horaInicio]} p/ #{options[:srvNome]}\n\n"
    content += if options[:regUrl]
      "Quer receber este e outros serviços grátis? Pergunte-me como e eu te explico\n\n-#{options[:prNome]}"
    else
      "*Logo após envie uma foto do novo visual, acumule pontos e troque por nossos serviços\n\n-#{options[:prNome]}"
    end

    fire_to(name, options, :remembering, true, get_date_to_send_sms_for(:remembering)) { content }
  end

  def send_sms_divulgation_to(name, options)
    @divulgationTitle = "SMS com instruções para divulgar <b>#{self.price.nome}</b>"
    url = options[:regUrl] || ENV["HOST_URL"]
    fire_to(name, options, :divulgation, true, get_date_to_send_sms_for(:divulgation)) { "Gostou do novo visual? Envie fotos do resultado p/ #{url}, acumule pontos e troque por nossos serviços\n\n-#{options[:prNome]}" }
  end

  def fire_to(name, options, sms_type, schedule = false, date = {})
    sms = get_sms_prefix(name, options)
    sms += yield
    sms = URI.encode(sms)
    instance_variable_set("@#{sms_type}", sms)  if name == :customer # usado para "salvar" sms e exibi-lo ao profissional.

    tel = ( name == :profissional ) ? options[:prTel] : options[:ctTel]
    fire(sms, tel, schedule, date)
  end

  def get_sms_prefix(name, options)
    ( name == :professional ) ? "SafiraSalões: SMS enviado p/#{options[:ctTel]}: " : ""
  end

  def fire(msg, tel, schedule = false, date = {})
    uri = "http://www.facilitamovel.com.br/api/simpleSend.ft?user=_SMS_USER_&password=_SMS_PASSWORD_&destinatario=_SMS_TELEFONE_&msg=_SMS_MSG_"
    uri.gsub!(/_SMS_USER_/, ENV['SMS_USER'])
    uri.gsub!(/_SMS_PASSWORD_/, ENV['SMS_PASSWORD'])
    uri.gsub!(/_SMS_MSG_/, msg)
    uri.gsub!(/_SMS_TELEFONE_/, tel)
    if schedule
      uri += "&day=_SMS_DAY_&month=_SMS_MONTH_&year=_SMS_YEAR_&formHour=_SMS_HOUR_&formMinute=_SMS_MINUTE_"
      uri.gsub!(/_SMS_DAY_/, date[:d])
      uri.gsub!(/_SMS_MONTH_/, date[:M])
      uri.gsub!(/_SMS_YEAR_/, date[:y])
      uri.gsub!(/_SMS_HOUR_/, date[:h])
      uri.gsub!(/_SMS_MINUTE_/, date[:m])
    end

    if Rails.env.production?
      Net::HTTP.get_response(URI(uri))
    else
      "6;123456".tap { |o| o.define_singleton_method(:body) { self } }
    end
  end

end
