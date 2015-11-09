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
#= require third-part/bootstrap
#= require third-part/typeahead/handlebars
#= require third-part/typeahead/typeahead.bundle
#= require third-part/jquery.nicescroll
#= require third-part/index
#= require third-part/jquery.easing.1.3
#= require third-part/bootbox
#= require third-part/moment
#= require third-part/bootstrap-datetimepicker
#= require third-part/fullcalendar
#= require third-part/pt-br
#= require third-part/jquery.maskedinput
#= require third-part/jquery-maskmoney.min
#= require third-part/jquery.cookie
#= require third-part/bootstrap-tour
#= require third-part/jquery.bootstrap.wizard
#= require third-part/jquery.bootstrap-touchspin
#= require third-part/modal-carousel
#= require third-part/modal-local
#= require third-part/carousel-fit
#= require jquery-ui/autocomplete
#= require third-part/jquery.autocomplete.category
#= require template/apps
#= require custom
#= require_tree .
#= require_self

# $(document).on 'hidden.bs.modal', '#myCarouselModal', (e) ->
#   $('iframe#player').attr('src', "https://www.youtube.com/embed/QUIeCtB15KY")

# Aplica máscara aos campos de dinheiro
$(document).on 'click, focus', 'input:text.money', ->
  $(this).maskMoney({
    prefix: 'R$ ',
    precision: 2,
    affixesStay: false,
    thousands: ''
    })

# Aplica máscara aos campos de recompensa
$(document).on 'click, focus', 'input:text.recompensa', ->
  $(this).maskMoney({
    suffix: ' safiras',
    precision: 0,
    affixesStay: false,
    thousands: ''
    })

$(document).on 'click, focus', 'input:text.cep', ->
  $(this).mask('99.999-999')

# Aplica máscara aos campos de telefone
$(document).on 'click, focus', 'input:text.telefone', ->
  elm = $(this)
  mask = if elm.val().length > 14 then "(99) 99999-9999" else "(99) 9999-9999?9"
  elm.mask(mask)

$(document).on 'click', 'a.sms_success_link', (event) ->
  title = event.toElement.dataset.title.replace(/%0A/g,"<br/>")
  title = decodeURIComponent(title)
  
  content = event.toElement.dataset.content.replace(/%0A/g,"<br/>")
  content = decodeURIComponent(content)

  $("#smsContentLabel").html(title)
  $("#smsContentBody").html(content)
  $("#smsContent").modal('show')
  event.preventDefault()

$('#prev_car_tour').on 'click', (e) ->
  $('#carousel-example-generic').carousel('prev')
  
$('#next_car_tour').on 'click', (e) ->
  $('#carousel-example-generic').carousel('next')

$('#prev_car_tour1').on 'click', (e) ->
  $('#carousel-doubt-tour').carousel('prev')
  
$('#next_car_tour1').on 'click', (e) ->
  $('#carousel-doubt-tour').carousel('next')

# Aplica máscara aos campos de telefone
$(document).on('focusout', 'input:text.telefone', ->
  phone = undefined
  element = undefined
  element = $(this)
  element.unmask()
  phone = element.val().replace(/\D/g, '')
  if phone.length > 10
    element.mask '(99) 99999-999?9'
  else
    element.mask '(99) 9999-9999?9'
  return
).trigger 'focusout'

# Tutorial
if $('.passos-tutorial').length
  tour = $('.passos-tutorial')
  autoStart = tour.data().autoStart
  
  tour = tour.data().tour
  tour['onHidden'] = (tour) ->
    window.started = false
  tour['onShown'] = (tour) ->
    window.started = true
    stp = tour.getStep(tour._current)
    elm = stp.element
    plc = stp.placement
    if plc == 'bottom'
      $('html, body').animate(
        {
          scrollTop: $(elm).offset().top
        }, 1000);
    else if plc == 'top'
      $('html, body').animate(
        {
          scrollTop: $(".popover-title").offset().top
        }, 1000);
  tour = new Tour(tour)
  tour.init()
  # tour.setCurrentStep(0)
  tour.restart() if autoStart
  window.tour = tour
  $('.passos-tutorial').click ->
    tour.restart()
    tour.init(true)

# Habilita popovers
$('[data-toggle="popover"]').popover()

# Insere na URL os ids das fotos de divulgação para que próximo passo
# (no processo de envio de fotos para divulgação de serviço) saiba
# quais fotos estão sendo enviadas
$(document).on 'click', '#photo_log_start_wizard', ->
  gen_restful_url($(this))

# Insere na URL a informação a respeito da inserção (ou não)
# das Informações de Contato do Profissional.
$(document).on 'click', '#photo_log_step_prof_info', ->
  gen_restful_url($(this))
  
  window.profInfoAdded ||= false
  params =  $.param('prof_info_allowed': window.profInfoAdded)

  $(this).attr 'href', ->
    this.href + '&' + params

gen_restful_url = (link) ->
  params =
    $('img.preview').map (i, el) ->
      $(el).attr('src').match /[0-9]+/

  params = $.makeArray params # map() retorna objeto. makeArray() retorna array 
  params = $.param('photos': params)
  
  link.attr 'href', ->
    if this.href.indexOf('?') == -1
      this.href + '?' + params
    else
      this.href + '&' + params


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