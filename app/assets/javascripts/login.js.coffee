jQuery ->
  if $("form#new_professional").length && typeof woopra != 'undefined'
    track_if_signed_up()

# Envia para o Woopra um evento informando
# acerca do cadastro de um profissional.
track_if_signed_up = ->
  woopra.track('professional_signed_up') if signed_up()

signed_up = ->
  query_string = {}
  query = window.location.search.substring(1)
  vars = query.split('&')
  i = 0
  while i < vars.length
    pair = vars[i].split('=')
    return true if pair[0] == 'signed_up'