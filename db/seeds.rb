# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
    password: '123456' }
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
  email: 'cristiano.souza.mendonca+aline@gmail.com'
  )

Service.create!([
  { nome: 'Corte Masculino',
    preco: 25.00,
    professional_id: p.id },
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
    professional_id: p.id },
  { nome: 'Corte Masculino',
    preco: 25.00,
    professional_id: p1.id },
  { nome: 'Corte Feminino',
    preco: 45.00,
    professional_id: p1.id },
  { nome: 'Unha mão',
    preco: 10.00,
    professional_id: p1.id },
  { nome: 'Unha pé',
    preco: 10.00,
    professional_id: p1.id },
  { nome: 'Unha mão e pé',
    preco: 15.00,
    professional_id: p1.id },
  { nome: 'Corte Masculino',
    preco: 25.00,
    professional_id: p2.id },
  { nome: 'Corte Feminino',
    preco: 45.00,
    professional_id: p2.id },
  { nome: 'Unha mão',
    preco: 10.00,
    professional_id: p2.id },
  { nome: 'Unha pé',
    preco: 10.00,
    professional_id: p2.id },
  { nome: 'Unha mão e pé',
    preco: 15.00,
    professional_id: p2.id }

  ])

Schedule.create!([
  { professional_id: p.id,
    customer_id: c.id,
    datahora_inicio: DateTime.now,
    datahora_fim: 1.hour.from_now.to_datetime,
    service_id: p.services.first.id },
  { professional_id: p1.id,
    customer_id: c.id,
    datahora_inicio: DateTime.now,
    datahora_fim: 1.hour.from_now.to_datetime,
    service_id: p1.services.first.id },
  { professional_id: p2.id,
    customer_id: c.id,
    datahora_inicio: DateTime.now,
    datahora_fim: 1.hour.from_now.to_datetime,
    service_id: p2.services.first.id }
  ])
