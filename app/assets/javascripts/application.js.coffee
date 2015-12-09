# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require jquery-fileupload
#= require third-part/jquery.cookie
#= require third-part/jquery.nicescroll
#= require third-part/bootstrap

# >>> AUXILIA NA FILTRAGEM E ORDENAÇÃO DE FOTOS - *Utilizado somente nos sites dos profissionais<<<
#= require third-part/jquery.mixitup

# >>> PERMITE A CRIAÇÃO DE CAIXAS DE DIÁLOGO UTILIZANDO OS 'MODAIS' DO BOOTSTRAP DE MODO SUCINTO <<<
#= require third-part/bootbox

# >>> UTILIZADO PARA CRIAR A CALCULADORA DE SAFIRAS - *Utilizado somente no área do profissional para convite <<<
#= require third-part/jquery.bootstrap-touchspin

# >>> UTILIZADO PARA A CRIAÇÃO DE MÁSCARAS EM CAMPOS HTML - *Utilizados no cadastro do profissional e na área para convite <<<
#= require third-part/jquery.maskedinput
#= require third-part/jquery-maskmoney.min

# >>> UTILTIZADO PARA A CRIAÇÃO DE TOURS - *Não sendo utilizado atualmente
# require third-part/bootstrap-tour

# >>> UTILIZADOS PARA A CRIAÇÃO DE CAROUSEL COM MODAL - *Não sendo utilizado atualmente
# require third-part/modal-carousel
# require third-part/modal-local
# require third-part/carousel-fit

# >>> UTILIZADOS PARA A CRIAÇÃO DE OPÇÕES DURANTE O PREENCHIMENTO - *Não sendo utilizado atualmente
# require jquery-ui/autocomplete
# require third-part/jquery.autocomplete.category

#= require template/apps
#= require custom
#= require_tree .
#= require_self

# Aplica máscara aos campos de recompensa
$(document).on 'click, focus', 'input:text.recompensa', ->
  $(this).maskMoney({
    suffix: ' safiras',
    precision: 0,
    affixesStay: false,
    thousands: ''
    })

# $(document).on 'click, focus', 'input:text.cep', ->
#   $(this).mask('99.999-999')

# Aplica máscara aos campos de telefone
$(document).on 'click, focus', 'input:text.telefone', ->
  elm = $(this)
  mask = if elm.val().length > 14 then "(99) 99999-9999" else "(99) 9999-9999?9"
  elm.mask(mask)

# Aplica máscara aos campos de telefone
$(document).on('focusout', 'input:text.telefone', ->
  phone = undefined
  element = undefined
  element = $(this)
  element.unmask()
  phone = element.val().replace(/\D/g, '')
  if phone.length == 11
    element.mask '(99) 99999-999?9', completed: get_customer(phone.length, phone)
  else
    element.mask '(99) 9999-9999?9', completed: get_customer(phone.length, phone)
  return
).trigger 'focusout'

get_customer = (phoneLength, phone) ->
  if phoneLength > 9
    $.ajax
      url: "/profissional/get_rewards_by_customers_telephone",
      type: 'post'
      dataType: "json"
      data:
        telefone: phone
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      success: (data, textStatus, jqXHR) ->
        $('#get_safiras_no').prop('checked', true)
        $("#invitation_customer_id").val(data.cId)
        if data.tSafiras > 0
          $('span.gathered_credits').text("R$ #{(data.tSafiras / 2).toFixed(2)}")
          $(".get_safiras_div").show()
        else
          $(".get_safiras_div").hide()

# # Tutorial
# if $('.passos-tutorial').length
#   tour = $('.passos-tutorial')
#   autoStart = tour.data().autoStart
  
#   tour = tour.data().tour
#   tour['onHidden'] = (tour) ->
#     window.started = false
#   tour['onShown'] = (tour) ->
#     window.started = true
#     stp = tour.getStep(tour._current)
#     elm = stp.element
#     plc = stp.placement
#     if plc == 'bottom'
#       $('html, body').animate(
#         {
#           scrollTop: $(elm).offset().top
#         }, 1000);
#     else if plc == 'top'
#       $('html, body').animate(
#         {
#           scrollTop: $(".popover-title").offset().top
#         }, 1000);
#   tour = new Tour(tour)
#   tour.init()
#   # tour.setCurrentStep(0)
#   tour.restart() if autoStart
#   window.tour = tour
#   $('.passos-tutorial').click ->
#     tour.restart()
#     tour.init(true)

# Habilita popovers
$('[data-toggle="popover"]').popover()

# Instruções abaixo fecham o modal caso usuário pressione back-button
$('div.modal').on 'show.bs.modal', ->
  modal = this
  hash = modal.id
  window.location.hash = hash

  window.onhashchange = ->
    if !location.hash
      $(modal).modal('hide')
  
$('div.modal').on 'hidden.bs.modal', ->
  hash = @id
  history.pushState '', document.title, window.location.pathname