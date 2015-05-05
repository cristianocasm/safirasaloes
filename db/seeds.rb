Status.create!([
  { nome: 'testando',
    descricao: 'Profissional realizou o cadastro, verificou o e-mail e tem acesso ao sistema durante período de teste',
    dias_vigencia: 7 },
  { nome: 'bloqueado',
    descricao: 'Profissional cancelou a assinatura ou utilizou integralmente o período de testes, não efetivou a assinatura e agora tem acesso ao sistema para somente visualizar a agenda',
    dias_vigencia: 7 },
  { nome: 'suspenso',
    descricao: 'Profissional cancelou a assinatura ou utilizou integralmente o período de testes, não efetivou a assinatura e agora está impedido de acessar o sistema',
    dias_vigencia: 60000 },
  { nome: 'assinante',
    descricao: 'Profissional que paga mensalmente para utilizar a plataforma',
    dias_vigencia: 60000 }
  ])

####

p = Professional.create!(
  { email: 'cristiano.souza.mendonca@gmail.com',
    password: '123456',
    nome: 'Beauty Saloon',
    telefone: '(33) 3333-3333',
    whatsapp: '(99) 9999-9999',
    pagina_facebook: 'https://www.facebook.com/BeautySaloonPage',
    rua: 'Bela',
    numero: '33',
    bairro: 'Beauty',
    cidade: 'Beauty Horizon',
    estado: 'MG',
    site: 'http://www.mybeautysite.com.br' }
  )
p1= Professional.create!(
  { email: 'cristiano.souza.mendonca+suspenso@gmail.com',
    password: '123456',
    status_id: Status.find_by_nome('suspenso').id }
  )
p2 = Professional.create!(
  { email: 'cristiano.souza.mendonca+bloqueado@gmail.com',
    password: '123456',
    status_id: Status.find_by_nome('bloqueado').id }
  )
p1.update_attribute(:status_id, Status.find_by_nome(:suspenso).id)
p2.update_attribute(:status_id, Status.find_by_nome(:bloqueado).id)

p.update_attribute(:confirmed_at, 1.day.ago)
p1.update_attribute(:confirmed_at, 1.day.ago)
p2.update_attribute(:confirmed_at, 1.day.ago)

c = Customer.create!(
  nome: 'Aline',
  email: 'cristiano.souza.mendonca+aline@gmail.com',
  password: '123456'
  )

Service.create!([
  { nome: 'Corte Masculino',
    preco: 25.00,
    professional_id: p.id,
    recompensa_divulgacao: 20 },
  { nome: 'Corte Feminino',
    preco: 45.00,
    professional_id: p.id },
  { nome: 'Unha mão',
    preco: 10.00,
    professional_id: p.id },
  { nome: 'Unha pé',
    preco: 10.00,
    professional_id: p.id },
  { nome: 'Unha mão e pé',
    preco: 15.00,
    professional_id: p.id }
#   { nome: 'Corte Masculino',
#     preco: 25.00,
#     professional_id: p1.id },
#   { nome: 'Corte Feminino',
#     preco: 45.00,
#     professional_id: p1.id },
#   { nome: 'Unha mão',
#     preco: 10.00,
#     professional_id: p1.id },
#   { nome: 'Unha pé',
#     preco: 10.00,
#     professional_id: p1.id },
#   { nome: 'Unha mão e pé',
#     preco: 15.00,
#     professional_id: p1.id },
#   { nome: 'Corte Masculino',
#     preco: 25.00,
#     professional_id: p2.id },
#   { nome: 'Corte Feminino',
#     preco: 45.00,
#     professional_id: p2.id },
#   { nome: 'Unha mão',
#     preco: 10.00,
#     professional_id: p2.id },
#   { nome: 'Unha pé',
#     preco: 10.00,
#     professional_id: p2.id },
#   { nome: 'Unha mão e pé',
#     preco: 15.00,
#     professional_id: p2.id }

  ])

Schedule.create!([
  { professional_id: p.id,
    customer_id: c.id,
    datahora_inicio: 1.hour.from_now.to_datetime,
    datahora_fim: 2.hours.from_now.to_datetime,
    service_id: p.services.first.id,
    nome: c.nome }
  ])
