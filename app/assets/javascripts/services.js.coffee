# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').fadeOut()
    event.preventDefault()

  # Cria campos para a definição de novo preço no cadastro de serviços.
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    active_popovers()
    active_calculator()
    event.preventDefault()

  # Caso o formulário seja submetido (com o pressionamento do botão
  # "enter", por exemplo) estando o profissional ainda no passo 1
  # do wizard, então, caso o nome do serviço tenha sido informado,
  # o profissional é repassado ao passo 2 do wizard.
  $('form').submit ->
    if $('#myWizard').wizard('selectedItem').step == 1
      if $("form #service_nome").val() != ""
        $('#myWizard').wizard('next')
      false
    else
      true

  $('form').on 'click', '.recompensa', (event) ->
    $(this).select()

  # Habilita botão "próximo" no wizard de cadastro de serviço quando
  # nome do serviço é informado.
  $('form #service_nome').bind "propertychange change click keyup input paste", ->
    if $(this).val() == ""
      $('button.btn-next').prop('disabled', true)
      $('button.btn-next').text('Informe o Nome do Serviço para Prosseguir')
    else
      $('button.btn-next').prop('disabled', false)
      $('button.btn-next').text('Próximo Passo >')

  # Cria os campos para definição do preço do serviço
  $('#myWizard').on 'actionclicked.fu.wizard', (evt, data) ->
    if data.step == 1 && data.direction == 'next'
      create_price_fields()

  # Esconde todos os popovers de dicas abertos quando
  # clique em qualquer lugar da página é realizado
  $('body').on 'click', (event) ->
    $('[data-toggle=popover]').each ->
      # hide any open popovers when the anywhere else in the body is clicked
      if (!$(this).is(event.target) && $(this).has(event.target).length == 0 && $('.popover').has(event.target).length == 0)
        $(this).popover('hide')

  # Habilita formulário de cadastro somente após o carregamento total do JS
  if $('form.service_form').length
    $('form.service_form').show()
    $('div#aguarde').hide()

  # Exibe/Esconde row da tabela que contém os preços de um
  # serviço com preço variável quando a row principal é
  # clicada
  $('table').on 'click', 'tr.preco_variavel', (event) ->
    $(this).next().fadeToggle(1000)

  # Esconde row da tabela que contém os preços de um
  # serviço com preço variável quando um click é dado
  # sobre ela
  $('table').on 'click', 'tr.contem_precos_e_recompensas', (event) ->
    $(this).fadeOut(1000)

create_price_fields = ->
  radio = $("form input[type=radio][name=service\\[preco_fixo\\]]:checked")
  if radio.val() == 'true'
    create_preco_fixo_fields(radio)
  else if radio.val() == 'false'
    create_preco_variavel_fields(radio)

create_preco_fixo_fields = (t) ->
  $('div#wizard_title').html('<h3>Defina o preço e a recompensa por divulgação para o serviço: <b><span id="nome_servico_span"></span></b> </h3> <br/>')
  $('span#nome_servico_span').html($('input#service_nome').val())
  $('div#fields').html($(t).data('fields'))
  $('div#fields').prepend($(t).data('prices'))
  $('input[type="submit"]').val('Salvar Serviço e Preço')
  active_popovers()
  active_calculator()
  
create_preco_variavel_fields = (t) ->
  time = new Date().getTime()
  regexp = new RegExp($(t).data('id'), 'g')
  $('div#wizard_title').html('<h3>Defina os preços e as recompensas por divulgação para o serviço: <b><span id="nome_servico_span"></span></b> </h3>')
  $('span#nome_servico_span').html($('input#service_nome').val())
  $('div#fields').html($(t).data('fields').replace(regexp, time))
  $('div#fields').prepend($(t).data('prices'))
  $('input[type="submit"]').val('Salvar Serviço e Preços')
  active_calculator()

active_popovers = () ->
  $('[data-toggle="popover"]').popover()

active_calculator = ->
  $('form .recompensa').bind 'propertychange change click keyup input paste', (event) ->
    saf = $(this).val().match(/\d+/)[0]
    cred = parseFloat(saf / 2).toFixed(2)
    $(this).parent().siblings().text("#{saf} safiras equivalem a R$ #{cred} em créditos que seus clientes poderão trocar por seus serviços")