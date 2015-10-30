# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if $('#calendar').length
    set_bindings()
    config_callendar()
    config_carousel()
    config_datetime_picker()
    load_events('profissional/schedules')
    launch_modal()
    # launch_typeahead()

config_datetime_picker = ->
  $('#schedule_data_inicio').datetimepicker({
    useCurrent: false
    locale: 'pt-br'
    format: 'DD/MM/YYYY'
    icons: {
      time: 'fa fa-clock-o'
      date: 'fa fa-calendar'
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
      previous: 'fa fa-chevron-left'
      next: 'fa fa-chevron-right'
      today: 'fa fa-calendar-check-o'
      clear: 'fa fa-trash-o'
      close: 'fa fa-close'
    }
  })

  $('#schedule_hora_inicio').datetimepicker({
    useCurrent: false
    locale: 'pt-br'
    format: 'HH:mm'
    icons: {
      time: 'fa fa-clock-o'
      date: 'fa fa-calendar'
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
      previous: 'fa fa-chevron-left'
      next: 'fa fa-chevron-right'
      today: 'fa fa-calendar-check-o'
      clear: 'fa fa-trash-o'
      close: 'fa fa-close'
    }
  })


  $('#schedule_data_fim').datetimepicker({
    locale: 'pt-br'
    format: 'DD/MM/YYYY'
    icons: {
      time: 'fa fa-clock-o'
      date: 'fa fa-calendar'
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
      previous: 'fa fa-chevron-left'
      next: 'fa fa-chevron-right'
      today: 'fa fa-calendar-check-o'
      clear: 'fa fa-trash-o'
      close: 'fa fa-close'
    }
  })

  $('#schedule_hora_fim').datetimepicker({
    locale: 'pt-br'
    format: 'HH:mm'
    icons: {
      time: 'fa fa-clock-o'
      date: 'fa fa-calendar'
      up: 'fa fa-chevron-up'
      down: 'fa fa-chevron-down'
      previous: 'fa fa-chevron-left'
      next: 'fa fa-chevron-right'
      today: 'fa fa-calendar-check-o'
      clear: 'fa fa-trash-o'
      close: 'fa fa-close'
    }
  })

# config_video_tour = (i, d) ->
#   if (i == 0 && d == 'right') || (i == 5 && d == 'left') # Vídeo tutorial
#     $('iframe#player').attr('src', "https://www.youtube.com/embed/QUIeCtB15KY?autoplay=1")
#     $('a.carousel-control, ol.carousel-indicators').hide()
#   else
#     $('iframe#player').attr('src', "https://www.youtube.com/embed/QUIeCtB15KY")
#     $('a.carousel-control, ol.carousel-indicators').show()

generate_mobile_caption = ->
  content = $("div.active div.carousel-caption").html()
  content = "" if content == undefined
  $("#content-for-mobile").html(content)

change_next_button = (i) ->
  if (i == 4) && $("#reward_definition_link").size() > 0
    $('a.carousel-control, ol.carousel-indicators').hide()
    $("#next_car_tour").addClass('hide')
    $("#create_reward_link").removeClass('hide')
  else
    $('a.carousel-control, ol.carousel-indicators').show()
    $("#next_car_tour").removeClass('hide')
    $("#create_reward_link").addClass('hide')


config_carousel = ->
  $("#carousel-example-generic").carousel({ interval: false } )
  # $("#carousel-example-generic").on 'slide.bs.carousel', (e) ->
  #   config_video_tour($('div.active').index(), e.direction)
  $("#carousel-example-generic").on 'slid.bs.carousel', (e) ->
    generate_mobile_caption() if $("#content-for-mobile").is(":visible")
    change_next_button($('div.active').index())
    woopra.track('tour_taken') if( ($('div.active').index() == 5) && (typeof woopra != 'undefined') )

  $('#prev_car_tour').on 'click', (e) ->
    $("#carousel-example-generic").carousel('prev')
  $('#next_car_tour').on 'click', (e) ->
    $("#carousel-example-generic").carousel('next')

config_callendar = ->
  $('#calendar').fullCalendar({
    header: {
      left: 'prev',
      center: 'title',
      right: 'month,agendaWeek,agendaDay,next'
    },
    defaultView: 'month'
    editable: true
    firstDay: 1
    fixedWeekCount: false
    allDaySlot: false
    displayEventEnd: true
    selectable: true
    selectHelper: true
    axisFormat: "HH:mm"
    minTime: "06:00:00"
    maxTime: "23:00:00"
    allDayDefault: false
    height: 'auto'
    timeFormat: 'HH:mm'
    eventColor: '#628a14'
    eventDrop:   (event, delta, revertFunc) -> dealChangeEvent(event, delta, revertFunc)
    eventResize: (event, delta, revertFunc) -> dealChangeEvent(event, delta, revertFunc)
    eventRender:     (event, element, view) -> assocPopOver(event, element, view)
    select:     (start, end, jsEvent, view) -> dealNewEvent(start, end, jsEvent, view)
  })

load_events = (source) ->
  $('#calendar').fullCalendar('addEventSource', source)

assocPopOver = (event, element, view) ->
  element.popover({
    title: event.title,
    placement: setPlacement(event, view),
    html: true,
    content: createContent(event),
    trigger: "click",
    delay: { "show": 0 },
    container:'body',
    template: "
    <div class='popover' role='tooltip'>
      <div class='arrow'></div>
      <h3 class='popover-title' style='overflow: hidden;'></h3>
      <div class='popover-content' style='overflow: auto;'></div>
      <div class='popover-footer'>
        <button type='button' class='btn btn-default btn-sm' onclick='$(this).parent().parent().popover(\"hide\")'><i class='fa fa-close'></i></button>
        <a class='btn btn-danger btn-sm' onclick='$(this).parent().parent().popover(\"hide\")' href='/profissional/schedules/#{event.id}' data-method='delete' data-remote='true'><i class='fa fa-trash-o'></i></a>
        <a class='btn btn-warning btn-sm' onclick='$(this).parent().parent().popover(\"hide\")' href='/profissional/schedules/#{event.id}/edit' data-remote='true'><i class='fa fa-pencil'></i></a>
      </div>
    </div>"
  });

createContent = (event) ->
  "Nome: #{event.nome}<br/>Tel: #{event.telefone}<br/>Serviço: #{event.price}"

setPlacement = (event, view) ->
  if view.name == 'month'
    if (event.start.get("date") > 15) then 'top' else 'bottom'
  else if view.name == 'agendaWeek' || view.name == 'agendaDay'
    if (event.start.get("hour") > 12) then 'top' else 'bottom'
  else
    $("#myModalError").modal(show: true)

dealChangeEvent = (event, delta, revertFunc) ->
  $.ajax
    url: "/profissional/schedules/#{event.id}",
    type: 'patch'
    dataType: "json"
    data:
      schedule:
        datahora_inicio: event.start.format(),
        datahora_fim: event.end.format()
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    success: (data, textStatus, jqXHR) ->
      $('#calendar').fullCalendar('render')
    error: (jqXHR, textStatus, errorThrown) ->
      $('#calendar').fullCalendar('refetchEvents')
      alert("Um erro inesperado ocorreu e não foi possível atualizar o horário.")

$(document).on 'click', 'button#btn_agendar, button.btn_tour_agendar', ->
  $('#calendar').fullCalendar( 'select', null)


launch_modal = ->
  params = window.location.search.substring(1)
  param = params.match(/servico=\d+/g)

  if param != null
    service_id = param[0].match(/servico=\d+/g)[0].split('=')[1]
    $('#schedule_price_id').val(service_id)
    $('#calendar').fullCalendar( 'select', null)

dealNewEvent = (start, end, jsEvent, view) ->
  # Para o caso onde botão é utilizado (data sempre será inválida)
  if !start.isValid() && !end.isValid()
    start = moment().utc().add(1, 'h').startOf('hour').local()
    end = moment().utc().add(1, 'h').startOf('hour').add(30, 'm').local()
  else if view.name == 'month'
    r = moment().utc().local()
    start = start.hour(r.hour()).add(1, 'h').startOf('hour').local()
    end = end.hour(r.hour()).subtract(1, 'd').add(1, 'h').startOf('hour').add(30, 'm').local()

  fillFields(start, end)
  $("div#errors").empty()
  $("#myModal").modal(show: true)


fillFields = (i, f) ->
  $("#schedule_data_inicio").val(i.format("DD/MM/YYYY"))
  $("#schedule_hora_inicio").val(i.format("HH:mm"))
  $("#schedule_data_fim").val(f.format("DD/MM/YYYY"))
  $("#schedule_hora_fim").val(f.format("HH:mm"))

################# INICIALIZANDO UTILIZAÇÃO DE TYPEAHEAD.JS PLUGIN #################

launch_typeahead = ->
  $('.twitter-typeahead.input-sm').siblings('input.tt-hint').addClass 'hint-small'
  $('.twitter-typeahead.input-lg').siblings('input.tt-hint').addClass 'hint-large'
  get_last_two_months_served_customers()

set_bindings = ->
  $('select#schedule_price_id').change check_whether_show_checkbox_for_safira_acceptance
  $('#myModal').bind 'hide.bs.modal', reset_form
  $('#myModal').on 'shown.bs.modal', (e) ->
    window.tour.next() if window.started
  $('input.twitter-typeahead').on 'typeahead:selected', (jQueryObj, selectedObj, datasetName) -> fill_form_with_customers_information(jQueryObj, selectedObj, datasetName)
  watch_over_customer_fields()

watch_over_customer_fields = ->
  $('.twitter-typeahead').each ->
    elem = $(this);
    nome = $("#schedule_nome")
    telefone = $("#schedule_telefone")
    ctId = $("#schedule_customer_id")
    
    #Save current value of element
    val = ""

    #Look for changes in the value
    elem.bind "propertychange input paste", ->
      #If value has changed...
      if( val != elem.val() )
        val = elem.val()
        if( $("#schedule_customer_id").val() != "" )
          if elem.attr('id') != 'schedule_nome'
            ctId.val("")
            nome.val("")
            telefone.typeahead('val', '')
            elem.typeahead('val', val)
            hide_checkbox()

check_whether_show_checkbox_for_safira_acceptance = () ->
  preco = $('option:selected').attr('preco')
  preco = parseFloat(preco)
  total_safiras = $("#total_safiras").val()

  if((preco * 2) <= total_safiras)
    show_checkbox()
  else
    hide_checkbox()

fill_form_with_customers_information = (jQueryObj, selectedObj, datasetName) ->
  $('#schedule_customer_id').val(selectedObj['id'])
  $('#schedule_nome').val(selectedObj['nome'])
  $('#schedule_telefone').typeahead('val', selectedObj['telefone'])
  get_customer_rewards(selectedObj['id'])

get_customer_rewards = (customer_id) ->
  $.ajax
    url: "/profissional/get_customer_rewards/#{customer_id}"
    type: 'post'
    dataType: 'json'
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    success: (data, textStatus, jqXHR) ->
      preco = $('option:selected').attr('preco')
      preco = parseFloat(preco)
      total_safiras = data['total_safiras']
      
      $("#total_safiras").val(total_safiras)
      check_whether_show_checkbox_for_safira_acceptance()
    error: (jqXHR, textStatus, errorThrown) ->

reset_form = ->
  $(this).find('form')[0].reset()
  $("#schedule_customer_id").val("") # Necessário já que hidden inputs não sofrem ação de form.reset()
  $("#schedule_id").val("") # Necessário já que hidden inputs não sofrem ação de form.reset()
  $("#total_safiras").val("") # Necessário já que hidden inputs não sofrem ação de form.reset()
  hide_checkbox()

hide_checkbox = ->
  $("div#pagamento_com_safiras").hide()
  $("input#schedule_pago_com_safiras").prop('disabled', true)

show_checkbox = ->
  $("div#pagamento_com_safiras").show()
  $("input#schedule_pago_com_safiras").prop('disabled', false)

new_bloodhound_telefone = (data) ->
  new Bloodhound
    name: 'customers'
    local: data
    remote: {
      url: "profissional/filter_by_telefone?t=%QUERY"
      wildcard: '%QUERY'
      ajax:
        method: 'POST'
        beforeSend: (xhr) ->
          $("#schedule_telefone").addClass("spinner")
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        complete: ->
          $("#schedule_telefone").removeClass("spinner")
    }
    dupDetector: (remoteMatch, localMatch) ->
      remoteMatch.telefone == localMatch.telefone
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace d.telefone
    queryTokenizer: Bloodhound.tokenizers.whitespace


# Função que retorna um Array dos clientes atendidos nos últimos 3 meses.
# 
# Esta função é chamada na inicialização do Bloodhound - para a definção
# do parâmetro 'local'.
#
# Este parâmetro tem como objetivo armazenar valores no cliente para de
# evitar algumas requisições ao servidor.
#
# Parte-se do princípio, portanto, que os clientes que visitaram o
# estabelecimento recentemente tem grandes possibilidades de o fazê-lo
# novamente dentro de 3 meses.
get_last_two_months_served_customers = (engine) ->
  $.ajax
    url: "/profissional/schedules/get_last_two_months_scheduled_customers"
    type: 'post'
    dataType: 'json'
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    success: (data, textStatus, jqXHR) ->    
      engine_telefone = new_bloodhound_telefone(data)
      engine_telefone.initialize()
      start_typeahead(engine_telefone, 'schedule_telefone', 'telefone', 1)
    error: (jqXHR, textStatus, errorThrown) ->

start_typeahead = (engine, elm, key, minLength) ->
  $("input##{elm}").typeahead(
    {
      minLength: minLength
      hint: true
      highlight: true
    },
    {
      name: 'customers'
      displayKey: key
      source: engine.ttAdapter()
    }
  )
