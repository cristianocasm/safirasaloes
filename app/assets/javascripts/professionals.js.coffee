jQuery ->
  $('#professional_pagina_facebook').on 'focus', ->
    if $(this).val() == '' then $(this).val('https://www.facebook.com/')
  $('#professional_site').on 'focus', ->
    if $(this).val() == '' then $(this).val('http://www.')
  $('.form-control').each ->
    elem = $(this);
    nome = $("#professional_nome")
    telefone = $("#professional_telefone")
    whatsapp = $("#professional_whatsapp")
    fb = $("#professional_pagina_facebook")
    rua = $("#professional_rua")
    num = $("#professional_numero")
    bairro = $("#professional_bairro")
    comp = $("#professional_complemento")
    cidade = $("#professional_cidade")
    estado = $("#professional_estado")
    site = $("#professional_site")

    #Save current value of element
    elem.data('oldVal', '');
    $("#info_contato").empty()
    update_preview(nome, telefone, whatsapp, fb, rua, num, bairro, comp, cidade, estado, site)
    #Look for changes in the value
    elem.bind "propertychange change click keyup input paste", ->
      #If value has changed...
      if (elem.data('oldVal') != elem.val())
        #Updated stored value
        elem.data('oldVal', elem.val());
        update_preview(nome, telefone, whatsapp, fb, rua, num, bairro, comp, cidade, estado, site)

update_preview = (nome, telefone, whatsapp, fb, rua, num, bairro, comp, cidade, estado, site) ->
  $("#info_contato").empty()
  $("#info_contato").append("#{if nome.val() != '' then '>>>>>> ' + nome.val() + ' <<<<<<<<<< <br/>' else ''}")
  $("#info_contato").append("#{if telefone.val() != '' then 'Telefone: ' + telefone.val() + '<br/>' else ''}")
  $("#info_contato").append("#{if whatsapp.val() != '' then 'WhatsApp: ' + whatsapp.val() + '<br/>' else '' }")
  $("#info_contato").append(gerar_endereco(rua.val(), num.val(), bairro.val(), comp.val(), cidade.val(), estado.val()))
  $("#info_contato").append("#{if fb.val() != '' then 'Facebook: <a target=\'_blank\' href=\''+fb.val()+ '\'>'+fb.val()+'</a>' + '<br/>' else ''}")
  $("#info_contato").append("#{if site.val() != '' then 'Site: <a target=\'_blank\' href=\''+site.val()+ '\'>'+site.val()+'</a>' + '<br/>' else ''}")

gerar_endereco = (rua, num, bairro, comp, cidade, estado) ->
  endereco = ""
  endereco = "#{if rua != '' then endereco + rua + ', ' else endereco}"
  endereco = "#{if num != '' then endereco + num + ', ' else endereco}"
  endereco = "#{if bairro != '' then endereco + bairro + ', ' else endereco}"
  endereco = "#{if comp != '' then endereco + comp + '. ' else endereco}"
  endereco = "#{if cidade != '' then endereco + cidade + ' - ' else endereco}"
  endereco = "#{if estado != '' then endereco + estado else endereco}"
  endereco = "#{if endereco != '' then 'Endereço: ' + endereco + '<br/>' else endereco}"
