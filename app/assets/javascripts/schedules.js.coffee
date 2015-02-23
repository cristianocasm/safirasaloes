# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  config_callendar()
  load_events('schedules')


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
    title: "My Title",
    placement: setPlacement(event, view),
    html: true,
    content: event.msg,
    trigger: "hover",
    delay: { "show": 0, "hide": 1000 }
  });

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
    hourFim = hour + 1
    minFim = min
  else
    $("#myModalError").modal(show: true)
    return

  fillFields(ano, mes, dia, hour, min, hourFim, minFim)
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

# $(document).ready(function() {
  
#     var date = new Date();
#     var d = date.getDate();
#     var m = date.getMonth();
#     var y = date.getFullYear();
    
#     $('#calendar').fullCalendar({
#       header: {
#         left: 'prev',
#         center: 'title',
#         right: 'month,agendaWeek,agendaDay,next'
#       },
#       editable: true,
#       firstDay: 1,
#       fixedWeekCount: false,
#       allDaySlot: false,
#       displayEventEnd: true,
#       selectable: true,
#       axisFormat: "HH:mm",
#       minTime: "06:00:00",
#       maxTime: "23:00:00",
#       allDayDefault: false,
#       /*dayClick: function(date, jsEvent, view) {

#         alert('Clicked on: ' + date.format());

#         alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);

#         alert('Current view: ' + view.name);

#         // change the day's background color just for fun
#         $(this).css('background-color', 'red');

#     },*/
#       /*eventClick: function(calEvent, jsEvent, view) {

#         alert('Event: ' + calEvent.title);
#         alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
#         alert('View: ' + view.name);

#         // change the border color just for fun
#         $(this).css('border-color', 'red');

#       },*/
#       events: [
#         {
#           title: 'All Day Event',
#           start: new Date(y, m, 1)
#         },
#         {
#           title: 'Long Event',
#           start: new Date(y, m, d-5),
#           end: new Date(y, m, d-2)
#         },
#         {
#           id: 999,
#           title: 'Repeating Event',
#           start: new Date(y, m, d-3, 16, 0),
#           allDay: false
#         },
#         {
#           id: 999,
#           title: 'Repeating Event',
#           start: new Date(y, m, d+4, 16, 0),
#           allDay: false
#         },
#         {
#           title: 'Meeting',
#           start: new Date(y, m, d, 10, 30),
#           allDay: false
#         },
#         {
#           title: 'Meeting',
#           start: new Date(y, m, d, 13, 30),
#           allDay: false
#         },
#         {
#           title: 'Meeting',
#           start: new Date(y, m, d, 15, 30),
#           allDay: false
#         },
#         {
#           title: 'Meeting',
#           start: new Date(y, m, d, 17, 30),
#           allDay: false
#         },
#         {
#           title: 'Meeting',
#           start: new Date(y, m, d, 20, 30),
#           end: new Date(y, m, d, 21, 30),
#           allDay: false
#         },
#         {
#           title: 'Lunch',
#           start: new Date(y, m, d, 12, 0),
#           end: new Date(y, m, d, 14, 0),
#           allDay: false
#         },
#         {
#           title: 'Birthday Party',
#           start: new Date(y, m, d+1, 19, 0),
#           end: new Date(y, m, d+1, 22, 30),
#           allDay: false
#         },
#         {
#           title: 'Click for Google',
#           start: new Date(y, m, 28),
#           end: new Date(y, m, 29),
#           url: 'http://google.com/'
#         }
#       ],
#       timeFormat: 'HH:mm'
#     });
    
# });