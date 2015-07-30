jQuery ->
  if typeof woopra != 'undefined'
    track_if_signed_up()
    track_if_confirmed()
    track_if_login()
    track_if_contact_info_defined()
    track_if_service_created()
    # O tracking de horário criado é feito no js retornado do servidor
    # para renderizar o horário

# Envia para o Woopra um evento informando
# acerca do cadastro de um profissional.
track_if_signed_up = ->
  # Não é necessário verificar se URL é diferente da URL de cadastro já que adição
  # do parâmetro 'signed_up' só ocorre no controller após a verificação de cadastro
  # realizado com sucesso.
  woopra.track('professional_signed_up', { plan: 'trial' }) if url_has_param('signed_up')

# Envia para o Woopra um evento informando
# acerca da confirmação do e-mail por um
# profissional
track_if_confirmed = ->
  # Não é necessário verificar URL já que adição do parâmetro 'email_confirmado'
  # só ocorre no controller após a verificação de e-mail confirmado com sucesso.
  woopra.track('professional_confirmed_email') if url_has_param('email_confirmado')

# Envia para o Woopra um evento informando
# acerca do login de um profissional ou cliente
track_if_login = ->
  # Verificação quanto a página atual ser diferente da página de login
  # se deve a possibilidade de erro no login e retorno para a mesma página
  if url_has_param('login') && distinct_urls("meu.safirasaloes.com.br/entrar", window.location.href)
    woopra.track('professional_login') if url_contains('profissional')
    woopra.track('customer_login') if url_contains('cliente')

# Envia ao Woopra um evento informando
# acerca do cadastro das informações de
# contato do profissional
track_if_contact_info_defined = ->
  # Verificação quanto a página atual ser diferente da página de informações de contato
  # se deve a possibilidade de erro na definição dessas informações e consequente retorno
  # para a mesma página
  woopra.track('professional_defined_contact') if url_has_param('contact_info_defined') && distinct_urls("meu.safirasaloes.com.br/edit", window.location.href)

# Envia ao Woopra um evento informando
# acerca do cadastro do primeiro serviço
# de um profissional
track_if_service_created = ->
  woopra.track('professional_created_service') if url_has_param('service_created') && distinct_urls("meu.safirasaloes.com.br/profissional/services/new", window.location.href)

# Encontra na URL parâmetros inseridos para
# tornar possível o tracking dos eventos do
# Woopra
url_has_param = (param) ->
  query_string = {}
  query = window.location.search.substring(1)
  vars = query.split('&')
  i = 0
  while i < vars.length
    pair = vars[i].split('=')
    i += 1
    return true if pair[0] == param

# Verifica a existência de uma palavra
# dentro da URL para tornar possível o
# tracking dos eventos do Woopra
url_contains = (param) ->
  window.location.href.indexOf(param) > -1

# Verifica se a url passada como parâmetro
# é a página de login.
distinct_urls = (ref, url) ->
  !(new RegExp(ref)).test(url)