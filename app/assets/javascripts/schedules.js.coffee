# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  config_callendar()
  load_events('schedules')
  launch_typeahead()


config_callendar = ->
  $('#calendar').fullCalendar({
    header: {
      left: 'prev',
      center: 'title',
      right: 'month,agendaWeek,agendaDay,next'
    },
    editable: true,
    firstDay: 1,
    fixedWeekCount: false,
    allDaySlot: false,
    displayEventEnd: true,
    selectable: true,
    axisFormat: "HH:mm",
    minTime: "06:00:00",
    maxTime: "23:00:00",
    allDayDefault: false,
    timeFormat: 'HH:mm',
    eventDrop:   (event, delta, revertFunc) -> dealChangeEvent(event, delta, revertFunc),
    eventResize: (event, delta, revertFunc) -> dealChangeEvent(event, delta, revertFunc),
    eventRender:     (event, element, view) -> assocPopOver(event, element, view),
    select:     (start, end, jsEvent, view) -> dealNewEvent(start, end, jsEvent, view)
  })

load_events = (source) ->
  $('#calendar').fullCalendar('addEventSource', source)

assocPopOver = (event, element, view) ->
  element.popover({
    title: createTitle(event),
    placement: setPlacement(event, view),
    html: true,
    content: event.msg,
    trigger: "hover",
    delay: { "show": 0, "hide": 1000 },
    template: '
    <div class="popover" role="tooltip">
      <div class="arrow"></div>
      <h3 class="popover-title"></h3>
      <div class="popover-content"></div>
    </div>'
  });

createTitle = (event) ->
  "#{event.title} <a href='/schedules/#{event.id}' data-method='delete' data-remote='true'><i class='fa fa-trash-o'></i></a> <a href='schedules/#{event.id}/edit' data-remote='true'><i class='fa fa-pencil'></i></a>"

setPlacement = (event, view) ->
  if view.name == 'month'
    if (event.start.get("date") > 15) then 'top' else 'bottom'
  else if view.name == 'agendaWeek' || view.name == 'agendaDay'
    if (event.start.get("hour") > 12) then 'top' else 'bottom'
  else
    $("#myModalError").modal(show: true)

dealChangeEvent = (event, delta, revertFunc) ->
  $.ajax
    url: "/schedules/#{event.id}",
    type: 'patch'
    dataType: "json"
    data:
      schedule:
        datahora_inicio: event.start.format(),
        datahora_fim: event.end.format()
    success: (data, textStatus, jqXHR) ->
      $('#calendar').fullCalendar('render')
    error: (jqXHR, textStatus, errorThrown) ->
      console.log textStatus
      $('#calendar').fullCalendar('refetchEvents')
      alert("Um erro inesperado ocorreu e não foi possível atualizar o horário.")

dealNewEvent = (start, end, jsEvent, view) ->
  ano = start.get("year")
  mes = start.get("month") + 1
  dia = start.get("date")

  if view.name == 'month'
    hour = 10
    min = 0
    hourFim = 11
    minFim = 0
  else if view.name == 'agendaWeek' || view.name == 'agendaDay'
    hour = start.get("hour")
    min = start.get("minute")
    hourFim = end.get("hour")
    minFim = end.get("minute")
  else
    $("#myModalError").modal(show: true)
    return

  fillFields(ano, mes, dia, hour, min, hourFim, minFim)
  $("div#errors").empty()
  $("#myModal").modal(show: true)

fillFields = (ano, mes, dia, hour, min, hourFim, minFim) ->
  $("#schedule_datahora_inicio_1i").val(ano)
  $("#schedule_datahora_inicio_2i").val(mes)
  $("#schedule_datahora_inicio_3i").val(dia)
  $("#schedule_datahora_inicio_4i").val(pad2(hour))
  $("#schedule_datahora_inicio_5i").val(pad2(min))
  $("#schedule_datahora_fim_1i").val(ano)
  $("#schedule_datahora_fim_2i").val(mes)
  $("#schedule_datahora_fim_3i").val(dia)
  $("#schedule_datahora_fim_4i").val(pad2(hourFim))
  $("#schedule_datahora_fim_5i").val(pad2(minFim))

pad2 = (number) ->
  (if number < 10 then '0' else '') + number

################# INICIALIZANDO UTILIZAÇÃO DE TYPEAHEAD.JS PLUGIN #################

launch_typeahead = ->
  $('.twitter-typeahead.input-sm').siblings('input.tt-hint').addClass 'hint-small'
  $('.twitter-typeahead.input-lg').siblings('input.tt-hint').addClass 'hint-large'
  $('input.twitter-typeahead').on 'typeahead:selected', (jQueryObj, selectedObj, datasetName) ->
    input = Pillbox($("#email_cliente"))
    input.add(selectedObj[email])
    $('#schedule_customer_id').val(selectedObj['id'])
    $('#nome_cliente').val(selectedObj['nome'])
    $('#email_cliente').typeahead('val', selectedObj['email'])
    $('#telefone_cliente').typeahead('val', selectedObj['telefone'])

  get_last_two_months_served_customers()

new_bloodhound_email = (data) ->
  new Bloodhound
    name: 'customers'
    local: data
    limit: 4
    remote: {
      url: "customers/filter_by_email?e=%QUERY"
      wildcard: '%QUERY'
      ajax: method: 'POST'
    }
    dupDetector: (remoteMatch, localMatch) ->
      remoteMatch.email == localMatch.email
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace d.email
    queryTokenizer: Bloodhound.tokenizers.whitespace

new_bloodhound_telefone = (data) ->
  new Bloodhound
    name: 'customers'
    local: data
    limit: 4
    remote: {
      url: "customers/filter_by_telefone?t=%QUERY"
      wildcard: '%QUERY'
      ajax: method: 'POST'
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
    url: "schedules/get_last_two_months_scheduled_customers"
    type: 'post'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      engine_email = new_bloodhound_email(data)
      engine_email.initialize()
      start_typeahead(engine_email, 'email_cliente', 'email', 6)
      
      engine_telefone = new_bloodhound_telefone(data)
      engine_telefone.initialize()
      start_typeahead(engine_telefone, 'telefone_cliente', 'telefone', 8)
    error: (jqXHR, textStatus, errorThrown) ->
      console.log textStatus

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

















# /* jQuery Notification */

# $(document).ready(function(){

#   setTimeout(function() {noty({text: '<strong>Howdy! Hope you are doing good...</strong>',layout:'topRight',type:'information',timeout:15000});}, 7000);

#   setTimeout(function() {noty({text: 'This is an all in one theme which includes Front End, Admin & E-Commerce. Dont miss it. Grab it now',layout:'topRight',type:'alert',timeout:13000});}, 9000);

# });


# $(document).ready(function() {

#   $('.noty-alert').click(function (e) {
#       e.preventDefault();
#       noty({text: 'Some notifications goes here...',layout:'topRight',type:'alert',timeout:2000});
#   });

#   $('.noty-success').click(function (e) {
#       e.preventDefault();
#       noty({text: 'Some notifications goes here...',layout:'top',type:'success',timeout:2000});
#   });

#   $('.noty-error').click(function (e) {
#       e.preventDefault();
#       noty({text: 'Some notifications goes here...',layout:'topRight',type:'error',timeout:2000});
#   });

#   $('.noty-warning').click(function (e) {
#       e.preventDefault();
#       noty({text: 'Some notifications goes here...',layout:'bottom',type:'warning',timeout:2000});
#   });

#   $('.noty-information').click(function (e) {
#       e.preventDefault();
#       noty({text: 'Some notifications goes here...',layout:'topRight',type:'information',timeout:2000});
#   });

# });