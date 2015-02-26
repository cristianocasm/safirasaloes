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

p = Professional.create!([
  { email: 'cristiano.souza.mendonca@gmail.com',
    password: '123456' }
  ])

c = Customer.create!(
  nome: 'Aline',
  email: 'cristiano.souza.mendonca+aline@gmail.com'
  )

Schedule.create!([
  { professional_id: p.first.id,
    customer_id: c.id,
    datahora_inicio: DateTime.now,
    datahora_fim: 1.hour.from_now.to_datetime }
  ])

Service.create!([
  { nome: 'Corte Masculino',
    preco: 25.00,
    professional_id: p.first.id },
  { nome: 'Corte Feminino',
    preco: 45.00,
    professional_id: p.first.id },
  { nome: 'Unha mão',
    preco: 10.00,
    professional_id: p.first.id },
  { nome: 'Unha pé',
    preco: 10.00,
    professional_id: p.first.id },
  { nome: 'Unha mão e pé',
    preco: 15.00,
    professional_id: p.first.id }
  ])