# == Schema Information
#
# Table name: professionals
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  nome                   :string(255)
#  telefone               :string(255)
#  cep                    :string(255)
#  rua                    :string(255)
#  numero                 :string(255)
#  bairro                 :string(255)
#  cidade                 :string(255)
#  estado                 :string(255)
#  complemento            :string(255)
#  profissao              :string(255)
#  local_trabalho         :string(255)
#  status_id              :integer
#  data_expiracao_status  :datetime
#  contato_definido       :boolean          default(FALSE)
#  site                   :string(255)
#  pagina_facebook        :string(255)
#  whatsapp               :string(255)
#  transacao_pagseguro    :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  oauth_token            :string(255)
#  oauth_expires_at       :datetime
#  avatar_url             :string(255)
#

class Professional < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :timeoutable

  belongs_to :status
  has_many :schedules
  has_many :services
  has_many :prices, through: :services
  has_many :rewards
  has_one :taken_step

  before_create :define_status, :build_taken_step
  # Os dois 'unless' abaixo foram introduzidos para que
  # profissionl possa alterar sua senha, mesmo se
  # ainda não tiver definido seu nome e/ou dados de contato.
  # Essa não é a melhor forma de fazer isso, tendo em vista
  # que se um dia o profissional puder alterar a senha no 
  # mesmo local onde ele define suas informações de contato,
  # então, o nome bem como suas informações de contato poderão
  # ficar em branco caso ele altere a senha - o que levaria a erros!!!
  validates_presence_of :nome, on: :update, unless: lambda { |pr| pr.encrypted_password_changed? }
  validate :contato_fornecido?,
           :formato_pagina_facebook,
           :formato_site,
            on: :update, unless: lambda { |pr| pr.encrypted_password_changed? }

  # Início Scopes Para Geração de Relatórios
  scope :count_cadastros, -> (start, hend) { where(created_at: start..hend).order("DATE(professionals.created_at) ASC").group("DATE(created_at)").count }
  scope :count_confirmacoes, -> (start, hend) { where(created_at: start .. hend).where("confirmed_at IS NOT NULL").order("DATE(professionals.created_at) ASC").group("DATE(created_at)").count }
  scope :count_tela_cadastro_contato_acessada, -> (start, hend) { joins(:taken_step).where("(professionals.created_at BETWEEN '#{start}' AND '#{hend}') AND taken_steps.tela_cadastro_contato_acessada = true").order("DATE(professionals.created_at) ASC").group("DATE(professionals.created_at)").count }
  scope :count_contato_cadastrado, -> (start, hend) { joins(:taken_step).where("(professionals.created_at BETWEEN '#{start}' AND '#{hend}') AND taken_steps.contato_cadastrado = true").order("DATE(professionals.created_at) ASC").group("DATE(professionals.created_at)").count }
  scope :count_tela_cadastro_servico_acessada, -> (start, hend) { joins(:taken_step).where("(professionals.created_at BETWEEN '#{start}' AND '#{hend}') AND taken_steps.tela_cadastro_servico_acessada = true").order("DATE(professionals.created_at) ASC").group("DATE(professionals.created_at)").count }
  scope :count_servico_cadastrado, -> (start, hend) { joins(:taken_step).where("(professionals.created_at BETWEEN '#{start}' AND '#{hend}') AND taken_steps.servico_cadastrado = true").order("DATE(professionals.created_at) ASC").group("DATE(professionals.created_at)").count }
  scope :count_tela_cadastro_horario_acessada, -> (start, hend) { joins(:taken_step).where("(professionals.created_at BETWEEN '#{start}' AND '#{hend}') AND taken_steps.tela_cadastro_horario_acessada = true").order("DATE(professionals.created_at) ASC").group("DATE(professionals.created_at)").count }
  scope :count_horario_cadastrado, -> (start, hend) { joins(:taken_step).where("(professionals.created_at BETWEEN '#{start}' AND '#{hend}') AND taken_steps.horario_cadastrado = true").order("DATE(professionals.created_at) ASC").group("DATE(professionals.created_at)").count }
  # Fim Scopes Para Geração de Relatórios

  def self.find_by_provider_and_uid_or_email(provider, uid, email)
    professional = self.where("( ( provider=? AND uid=? ) OR email=? )", provider, uid, email).try(:first)
    
    # Ao invés de apenas retornar o profissional encontrado,
    # verifico se ele já confirmou o e-mail (necessário quando)
    # cadastro é realizado manualmente. Caso não, atualizo essa
    # informação para que ele não tenha que realizar esse processo.
    if professional.present?
      if professional.confirmed_at.present?
        professional
      else
        professional.tap { |prof| prof.update_attribute(:confirmed_at, Time.now) }
      end
    end
  end

  def creating_first_service?
    self.services.size == 0
  end

  def self.taken_steps_report(start, hend)
    cad = count_cadastros(start, hend)
    totalDays = (hend - start).to_i
    
    xLabels = generate_x_labels(cad, start, hend)
    dadosNorm = normalizar(
                  formatar(cad, "Nº Cadastros", "#ff6c24", start, hend),
                  formatar(count_confirmacoes(start, hend), "Nº Confirmados", "#ee5b13", start, hend),
                  formatar(count_tela_cadastro_contato_acessada(start, hend), "Nº TC Contato", "#dd4a13", start, hend),
                  formatar(count_contato_cadastrado(start, hend), "Nº Contato Cad", "#cc4a13", start, hend),
                  formatar(count_tela_cadastro_servico_acessada(start, hend), "Nº TC Servico", "#bb4a13", start, hend),
                  formatar(count_servico_cadastrado(start, hend), "Nº Serviço Cad", "#aa4a13", start, hend),
                  formatar(count_tela_cadastro_horario_acessada(start, hend), "Nº TC Horário", "#994a13", start, hend),
                  formatar(count_horario_cadastrado(start, hend), "Nº Horário Cad", "#884a13", start, hend),
                  totalDays
                )

    return  [ xLabels, dadosNorm ]
  end

  def update_taken_step(step)
    step.each { |key, val| self.taken_step.update_attribute(key.to_sym, val) }
  end

  def contact_info
    contactInfo = ""
    contactInfo << "Responsável: #{nome.titleize} \n"
    contactInfo << (telefone.present? ? "Telefone: #{telefone}\n" : "")
    contactInfo << (whatsapp.present? ? "WhatsApp: #{whatsapp}\n" : "")
    contactInfo << gerar_endereco
    contactInfo << (pagina_facebook.present? ? "Facebook: #{pagina_facebook}\n" : "")
    contactInfo << (site.present? ? "Site: #{site}\n" : "")
  end

  def gerar_endereco
    endereco = ""
    endereco << (rua.present? ? "#{rua}, " : "")
    endereco << (numero.present? ? "#{numero}, " : "")
    endereco << (bairro.present? ? "#{bairro}, " : "")
    endereco << (complemento.present? ? "#{complemento}. " : "")
    endereco << (cidade.present? ? "#{cidade} - " : "")
    endereco << (estado.present? ? "#{estado}" : "")
    endereco = (endereco.present? ? "Endereço: #{endereco}\n" : "")
  end

  def set_contato_definido
    self.contato_definido = true
  end

  def contato_fornecido?
    if %w(telefone whatsapp).all?{|attr| self[attr].blank?}
      errors.add :base, "Informe um Telefone ou WhatsApp para contato."
    else
      set_contato_definido
    end
  end

  def formato_pagina_facebook
    return if pagina_facebook.blank?
    unless /https:\/\/www\.facebook\.com\/.+/ =~ self[:pagina_facebook]
      errors.add :pagina_facebook, "deve começar com 'https://www.facebook.com/'"
    end
  end

  def formato_site
    return if site.blank?
    unless /http:\/\/www\..+/ =~ self[:site]
      errors.add :site, "deve começar com 'http://www.'"
    end
  end

  def schedules_to_calendar(start, hend)
    scs = self.schedules.where(updated_at: start..hend).includes(:price)
    transform(scs)
  end

  def services_ordered
    services.includes(:prices).order(:nome)
  end

  def has_contato_definido?
    self.contato_definido
  end

  def has_servico_definido?
    !self.services.blank?
  end
  
  def suspenso?
    true if self.status.nome == 'suspenso'
  end

  def bloqueado?
    true if self.status.nome == 'bloqueado'    
  end

  def testando?
    true if self.status.nome == 'testando'
  end

  def assinante?
    true if self.status.nome == 'assinante'
  end

  def status_equal_to?(status)
    update_status
    self.status.nome == status.to_s
  end

  def self.create_with_omniauth(auth)
    create! do |professional|
      professional.provider = auth.provider
      professional.uid = auth.uid
      professional.oauth_token = auth.credentials.token
      professional.oauth_expires_at =  Time.at(auth.credentials.expires_at)
      professional.email = auth.info.email
      professional.confirmed_at = Time.now
      professional.avatar_url = auth.info.image
      professional.nome = auth.extra.raw_info.first_name
    end
  end

  private

  def self.normalizar(cadastros, confirmacoes, tCContato, contatoCad, tCServico, servicoCad, tCHorario, horarioCad, totalDays)
    totalDays.times do |i|

      cad = cadastros[:data][i][1]
      
      unless cadastros[:data][i][1] == 0
        cadastros[:data][i][1] = (( cad.to_f / cad )*100).round(0)         # C2
        confirmacoes[:data][i][1] = (( confirmacoes[:data][i][1].to_f / cad )*100).round(0)   # C3
        tCContato[:data][i][1] = (( tCContato[:data][i][1].to_f / cad )*100).round(0)         # C4
        contatoCad[:data][i][1] = (( contatoCad[:data][i][1].to_f / cad )*100).round(0)       # C5
        tCServico[:data][i][1] = (( tCServico[:data][i][1].to_f / cad )*100).round(0)         # C6
        servicoCad[:data][i][1] = (( servicoCad[:data][i][1].to_f / cad )*100).round(0)       # C7
        tCHorario[:data][i][1] = (( tCHorario[:data][i][1].to_f / cad )*100).round(0)         # C8
        horarioCad[:data][i][1] = (( horarioCad[:data][i][1].to_f / cad )*100).round(0)       # C9
      end

    end

    return  [
              cadastros,
              confirmacoes,
              tCContato,
              contatoCad,
              tCServico,
              servicoCad,
              tCHorario,
              horarioCad
            ]
  end

  def self.formatar(data, label, color, start, _end)
    arr = generate_data_array(data, start, _end)
    {
      label: label,
      data: arr,
      color: color
    }
  end

  def self.generate_data_array(data, start, _end)
    i = -1
    arr = []
    data.default = 0
    start.upto(_end-1.day) { |date| arr << [ (i += 1) , data[date] ] }
    arr
  end

  def self.generate_x_labels(data, start, _end)
    i = -1
    arr = []
    data.default = 0
    start.upto(_end-1.day) { |date| arr << [ (i += 1) , date.strftime('%d/%m') ] }
    arr
  end


  def transform(scs)
    scs.map do |sc|
      {
        id:    sc.id,
        title: sc.nome,
        email: sc.email,
        nome: sc.nome,
        telefone: sc.telefone,
        price: sc.price.nome,
        start: sc.datahora_inicio,
        end:   sc.datahora_fim
      }
    end
  end

  def update_status
    if status_expired?
      nextStatus = next_status
      self.update(status_id: nextStatus.id, data_expiracao_status: Time.zone.now + nextStatus.dias_vigencia.days)
    end
  end

  def next_status
    if self.status.nome == 'testando'
      Status.find_by_nome 'bloqueado'
    elsif self.status.nome == 'bloqueado'
      Status.find_by_nome 'suspenso'
    end
  end

  def status_expired?
    (self.status.nome == 'testando' || self.status.nome == 'bloqueado') &&
      self.data_expiracao_status < Time.zone.now
  end

  def define_status
    status = Status.find_by_nome('testando')
    self.status_id = status.id
    self.data_expiracao_status = Time.zone.now + status.dias_vigencia.days
  end

  # Sobrescrevendo método que ativa validações no e-mail
  # para que e-mail não seja obrigatório nos casos onde
  # cadastro é realizado com sistemas de terceiros.
  def email_required?
    super && provider.blank? && uid.blank?
  end

  # Sobrescrevendo método que ativa validações no password
  # para que password não seja obrigatório nos casos onde
  # cadastro é realizado com sistemas de terceiros.
  def password_required?
    super && provider.blank? && uid.blank?
  end
end

