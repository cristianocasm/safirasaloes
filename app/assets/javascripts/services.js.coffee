# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if $('form.service_form').length
    initialize_calculators()

  # Remove campos para a definição de novo preço no cadastro de serviços.
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    if $('fieldset.price_fields:visible').length == 1
      $('div.optional').hide()
      set_fixed_price(true)
    event.preventDefault()

  # Cria campos para a definição de novo preço no cadastro de serviços.
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    
    initialize_calculator($(this).prev().find(".recompensa")[0])
    activate_popovers()
    set_fixed_price(false)
    $('div.optional').show()
    event.preventDefault()

  # Seleciona todo o conteúdo presente no campo de recompensa para
  # facilitar preenchimento e evitar confusão.
  $('form').on 'click', '.recompensa', (event) ->
    $(this).select()

  # Esconde todos os popovers de dicas abertos quando
  # clique em qualquer lugar da página é realizado
  $('body').on 'click', (event) ->
    $('[data-toggle=popover]').each ->
      # hide any open popovers when the anywhere else in the body is clicked
      if (!$(this).is(event.target) && $(this).has(event.target).length == 0 && $('.popover').has(event.target).length == 0)
        $(this).popover('hide')

  # Exibe/Esconde row da tabela que contém os preços de um
  # serviço com preço variável quando a row principal é
  # clicada
  $('table').on 'click', 'a.preco_variavel', (e) ->
    details = $(this).closest('tr').next()
    target = $(e.target).closest('a')
    
    if details.is(':visible')
      target.removeClass('active')
    else
      $("tr.contem_precos_e_recompensas:visible").fadeToggle()
      target.addClass('active')

    details.fadeToggle(1000)
    event.preventDefault()

  $("a.add_fields").popover({
    title: "Preço varia? <a style='float: right' onclick='$(this).parent().parent().popover(\"hide\")'><i class='fa fa-close'></i></a>",
    placement: 'right',
    content: 'Adicione um novo preço',
    trigger: "hover",
    container: 'body',
    html: true,
    template: "
    <div class='popover' role='tooltip'>
      <div class='arrow'></div>
      <h3 class='popover-title' style='overflow: hidden; background-color: #f6bb42; color: white;'></h3>
      <div class='popover-content' style='overflow: auto;'></div>
    </div>"
  }).popover('show')

set_fixed_price = (bool) ->
  $('#service_preco_fixo').val(bool)

activate_popovers = () ->
  $('[data-toggle="popover"]').popover()

initialize_calculators = ->
  $('form .recompensa').each (i, e) ->
    initialize_calculator(e)

initialize_calculator = (e) ->
  $(e).TouchSpin(
    postfix: "equivale a R$ 0.00"
    min: 0
    max: 1000000000
  )

  activate_calculator(e)

  $(e).bind 'propertychange change click keyup input paste', (event) ->
    activate_calculator(e)

activate_calculator = (e) ->
  saf = $(e).val().match(/\d+/)
  saf == null ? 0 : saf[0]
  cred = parseFloat(saf / 2).toFixed(2)
  calc = $(e).siblings("span.bootstrap-touchspin-postfix")
  calc.text("equivale a R$ #{cred}")
  calc.bind 'click', (event) ->
    $(e).focus()


