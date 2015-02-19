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