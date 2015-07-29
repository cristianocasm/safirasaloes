jQuery ->
  if typeof woopra != 'undefined'
    if $("form#new_professional").length
      track_if_signed_up()
      track_if_confirmed()

    if is_login_page(document.referrer) && !is_login_page(window.location.href)
      track_login_event()

# Envia para o Woopra um evento informando
# acerca do cadastro de um profissional.
track_if_signed_up = ->
  woopra.track('professional_signed_up', { plan: 'trial' }) if url_has_param('signed_up')

# Envia para o Woopra um evento informando
# acerca da confirmação do e-mail por um
# profissional
track_if_confirmed = ->
  woopra.track('professional_confirmed_email') if url_has_param('email_confirmado')

track_login_event = ->
  woopra.track('professional_login') if url_contains('profissional')
  woopra.track('customer_login') if url_contains('cliente')

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
is_login_page = (url) ->
  (new RegExp("meu.safirasaloes.com.br/entrar")).test(url)