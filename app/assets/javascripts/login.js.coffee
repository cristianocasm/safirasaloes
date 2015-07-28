jQuery ->
  if $("form#new_professional").length && typeof woopra != 'undefined'
    track_if_signed_up()
    track_if_confirmed()

# Envia para o Woopra um evento informando
# acerca do cadastro de um profissional.
track_if_signed_up = ->
  woopra.track('professional_signed_up', { plan: 'trial' }) if url_has('signed_up')

track_if_confirmed = ->
  woopra.track('professional_confirmed_email') if url_has('email_confirmado')

url_has = (param) ->
  query_string = {}
  query = window.location.search.substring(1)
  vars = query.split('&')
  i = 0
  while i < vars.length
    pair = vars[i].split('=')
    i += 1
    return true if pair[0] == param