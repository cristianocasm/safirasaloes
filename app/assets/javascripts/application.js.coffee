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

# >>> 
#= require third-part/jquery.mixitup

# >>> PERMITE A CRIAÇÃO DE CAIXAS DE DIÁLOGO UTILIZANDO OS 'MODAIS' DO BOOTSTRAP DE MODO SUCINTO <<<
#= require third-part/bootbox

#= require third-part/jquery.bootstrap-touchspin
#= require third-part/jquery.maskedinput
#= require third-part/jquery-maskmoney.min
#= require third-part/bootstrap-tour
#= require third-part/modal-carousel
#= require third-part/modal-local
#= require third-part/carousel-fit
#= require jquery-ui/autocomplete
#= require third-part/jquery.autocomplete.category
#= require template/apps
#= require custom
#= require_tree .
#= require_self




# require jquery
# require jquery_ujs
# require jquery-fileupload
# require third-part/bootstrap
# require third-part/typeahead/handlebars
# require third-part/typeahead/typeahead.bundle
# require third-part/jquery.nicescroll
# require third-part/index
# require third-part/jquery.easing.1.3
# require third-part/bootbox
# require third-part/moment
# require third-part/bootstrap-datetimepicker
# require third-part/fullcalendar
# require third-part/pt-br
# require third-part/jquery.maskedinput
# require third-part/jquery-maskmoney.min
# require third-part/jquery.cookie
# require third-part/bootstrap-tour
# require third-part/jquery.bootstrap.wizard
# require third-part/jquery.bootstrap-touchspin
# require third-part/modal-carousel
# require third-part/modal-local
# require third-part/carousel-fit
# require jquery-ui/autocomplete
# require third-part/jquery.autocomplete.category
# require template/apps
# require custom
# require_tree .
# require_self



# $(document).on 'hidden.bs.modal', '#myCarouselModal', (e) ->
#   $('iframe#player').attr('src', "https://www.youtube.com/embed/QUIeCtB15KY")

# # Aplica máscara aos campos de dinheiro
# $(document).on 'click, focus', 'input:text.money', ->
#   $(this).maskMoney({
#     prefix: 'R$ ',
#     precision: 2,
#     affixesStay: false,
#     thousands: ''
#     })

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

# $(document).on 'click', 'a.sms_success_link', (event) ->
#   title = event.toElement.dataset.title.replace(/%0A/g,"<br/>")
#   title = decodeURIComponent(title)
  
#   content = event.toElement.dataset.content.replace(/%0A/g,"<br/>")
#   content = decodeURIComponent(content)

#   $("#smsContentLabel").html(title)
#   $("#smsContentBody").html(content)
#   $("#smsContent").modal('show')
#   event.preventDefault()

# $('#prev_car_tour').on 'click', (e) ->
#   $('#carousel-example-generic').carousel('prev')
  
# $('#next_car_tour').on 'click', (e) ->
#   $('#carousel-example-generic').carousel('next')

# $('#prev_car_tour1').on 'click', (e) ->
#   $('#carousel-doubt-tour').carousel('prev')
  
# $('#next_car_tour1').on 'click', (e) ->
#   $('#carousel-doubt-tour').carousel('next')


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


# # Insere na URL os ids das fotos de divulgação para que próximo passo
# # (no processo de envio de fotos para divulgação de serviço) saiba
# # quais fotos estão sendo enviadas
# $(document).on 'click', '#photo_log_start_wizard', ->
#   gen_restful_url($(this))

# # Insere na URL a informação a respeito da inserção (ou não)
# # das Informações de Contato do Profissional.
# $(document).on 'click', '#photo_log_step_prof_info', ->
#   gen_restful_url($(this))
  
#   window.profInfoAdded ||= false
#   params =  $.param('prof_info_allowed': window.profInfoAdded)

#   $(this).attr 'href', ->
#     this.href + '&' + params

# gen_restful_url = (link) ->
#   params =
#     $('img.preview').map (i, el) ->
#       $(el).attr('src').match /[0-9]+/

#   params = $.makeArray params # map() retorna objeto. makeArray() retorna array 
#   params = $.param('photos': params)
  
#   link.attr 'href', ->
#     if this.href.indexOf('?') == -1
#       this.href + '?' + params
#     else
#       this.href + '&' + params


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

# Lida com clique nos botões que levam à divulgação do trabalho
# dos profissionais
$('.fb-enjoy').on 'click', ->
  that = $(this).data()

  # calling the API ...
  obj = {
    method: that.method
    link: that.link
    picture: that.picture
    name: that.name
    caption: that.caption
    description: that.description
  }

  callback = (response) ->
    if response != null && typeof response.post_id != 'undefined'
      
      bootbox.dialog(
        title: "Aguarde...",
        message: "Estamos fornecendo suas safiras."
      )
      
      $.post('/cliente/assign_rewards_to_customer', { 'photo_id': that.photoId, 'telefone': that.telefone, 'recompensar': that.recompensar }, null, 'script')
    else
      $("div.alert.alert-warning.fade.in").addClass("hidden")
      bootbox.dialog(
        title: "Falta só 1 passo...",
        message: "<p>Compartilhe <span class='text-strong'>pelo menos 1 foto</span> para receber as recompensas.</p>",
        buttons:
          danger:
            label: "Não. Obrigado."
            className: 'btn-default'
          success:
            label: "OK! Vamos lá!"
            className: 'btn-success'
      )



  FB.ui(obj, callback)
  $("div.alert.alert-warning.fade.in").removeClass("hidden")

# Garante que botões do Facebook só são visíveis quando toda a página é carregada
jQuery ->
  $(".aguarde").hide()
  $(".share_buttons").show()