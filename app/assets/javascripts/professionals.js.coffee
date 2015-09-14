jQuery ->
  $('.form-control').each ->
    elem = $(this);
    nome = $("#professional_nome")
    telefone = $("#professional_telefone")
    whatsapp = $("#professional_whatsapp")
    cep = $("#professional_cep")
    rua = $("#professional_rua")
    num = $("#professional_numero")
    bairro = $("#professional_bairro")
    comp = $("#professional_complemento")
    cidade = $("#professional_cidade")
    estado = $("#professional_estado")

    #Save current value of element
    elem.data('oldVal', '');
    $("#info_contato").empty()
    update_preview(nome, telefone, whatsapp, rua, num, bairro, comp, cidade, estado)
    #Look for changes in the value
    elem.bind "propertychange change click keyup input paste", ->
      #If value has changed...
      if (elem.data('oldVal') != elem.val())
        #Updated stored value
        elem.data('oldVal', elem.val());
        if elem.val() == cep.val() && cep.val().length == 8
          $("#professional_cep").addClass("spinner")
          get_full_address(cep, nome, telefone, whatsapp, rua, num, bairro, comp, cidade, estado)
        else
          update_preview(nome, telefone, whatsapp, rua, num, bairro, comp, cidade, estado)

get_full_address = (cep, nome, telefone, whatsapp, rua, num, bairro, comp, cidade, estado) ->
  $.getJSON "http://api.postmon.com.br/v1/cep/#{cep.val()}", (address) ->
    rua.val(address.logradouro)
    bairro.val(address.bairro)
    cidade.val(address.cidade)
    estado.val(address.estado)
    update_preview(nome, telefone, whatsapp, rua, num, bairro, comp, cidade, estado)
    $("#professional_cep").removeClass("spinner")

update_preview = (nome, telefone, whatsapp, rua, num, bairro, comp, cidade, estado) ->
  $("#info_contato").empty()
  $("#info_contato").append("#{if nome.val() != '' then 'Responsável: ' + nome.val() + '<br/>' else ''}")
  $("#info_contato").append("#{if telefone.val() != '' then 'Telefone: ' + telefone.val() + '<br/>' else ''}")
  $("#info_contato").append("#{if whatsapp.val() != '' then 'WhatsApp: ' + whatsapp.val() + '<br/>' else '' }")
  $("#info_contato").append(gerar_endereco(rua.val(), num.val(), bairro.val(), comp.val(), cidade.val(), estado.val()))
  $("#info_contato").append("---<br/>")

gerar_endereco = (rua, num, bairro, comp, cidade, estado) ->
  endereco = ""
  endereco = "#{if rua != '' then endereco + rua + ', ' else endereco}"
  endereco = "#{if num != '' then endereco + num + ', ' else endereco}"
  endereco = "#{if bairro != '' then endereco + bairro + ', ' else endereco}"
  endereco = "#{if comp != '' then endereco + comp + '. ' else endereco}"
  endereco = "#{if cidade != '' then endereco + cidade + ' - ' else endereco}"
  endereco = "#{if estado != '' then endereco + estado else endereco}"
  endereco = "#{if endereco != '' then 'Endereço: ' + endereco + '<br/>' else endereco}"
