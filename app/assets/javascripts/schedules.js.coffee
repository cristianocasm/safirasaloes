# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
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
    
    events: [
    ]
  })

    
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