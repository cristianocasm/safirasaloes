# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if $('#calendar').length
    set_bindings()
    config_callendar()
    config_carousel()
    load_events('profissional/schedules')
    # launch_typeahead()

$(document).on 'click', 'button#btn_agendar', ->
  c = $('#calendar')
  s = null
  e = null

  if c.fullCalendar( 'getView' ).type == "month"
    s = moment().utc()
    e = moment().utc().add(1, 'd')
  else
    s = moment.utc().add(1, 'h').startOf('hour').local()
    e = moment.utc().add(1, 'h').startOf('hour').add(30, 'm').local()

  c.fullCalendar( 'select', s, e )

config_carousel = ->
  $("#carousel-example-generic").carousel( { interval: false } )
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

dealNewEvent = (start, end, jsEvent, view) ->
  anoI = start.get("year")
  mesI = start.get("month") + 1
  diaI = start.get("date")

  anoF = end.get("year")
  mesF = end.get("month") + 1
  diaF = end.get("date")

  if view.name == 'month'
    hourI = 10
    minI = 0
    hourF = 11
    minF = 0
    diaF = diaF - 1
  else if view.name == 'agendaWeek' || view.name == 'agendaDay'
    hourI = start.get("hour")
    minI = start.get("minute")
    hourF = end.get("hour")
    minF = end.get("minute")
  else
    $("#myModalError").modal(show: true)
    return

  fillFields(anoI, mesI, diaI, hourI, minI, anoF, mesF, diaF, hourF, minF)
  $("div#errors").empty()
  $("#myModal").modal(show: true)

fillFields = (anoI, mesI, diaI, hourI, minI, anoF, mesF, diaF, hourF, minF) ->
  $("#schedule_datahora_inicio_1i").val(anoI)
  $("#schedule_datahora_inicio_2i").val(mesI)
  $("#schedule_datahora_inicio_3i").val(diaI)
  $("#schedule_datahora_inicio_4i").val(pad2(hourI))
  $("#schedule_datahora_inicio_5i").val(pad2(minI))
  $("#schedule_datahora_fim_1i").val(anoF)
  $("#schedule_datahora_fim_2i").val(mesF)
  $("#schedule_datahora_fim_3i").val(diaF)
  $("#schedule_datahora_fim_4i").val(pad2(hourF))
  $("#schedule_datahora_fim_5i").val(pad2(minF))

pad2 = (number) ->
  (if number < 10 then '0' else '') + number

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
