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
#= require respond.min
#= require bootstrap.min
#= require jquery-ui.min
#= require moment.min
#= require fullcalendar
#= require pt-br
#= require jquery.rateit.min
#= require jquery.prettyPhoto
#= require jquery.slimscroll.min
#= require jquery.dataTables.min
#= require excanvas.min
#= require jquery.flot
#= require jquery.flot.resize
#= require jquery.flot.pie
#= require jquery.flot.stack
#= require jquery.noty
#= require themes/default
#= require layouts/bottom
#= require layouts/topRight
#= require layouts/top
#= require sparklines
#= require jquery.cleditor.min
#= require bootstrap-datetimepicker.min
#= require jquery.onoff.min
#= require filter
#= require custom
#= require charts
#= require jquery-maskmoney.min
#= require typeahead.bundle
#= require private_pub
#= require_tree .
#= require_self

# Aplica máscara aos campos de dinheiro
$(document).on 'click, focus', 'input:text.money', ->
  $(this).maskMoney({
    prefix: 'R$ ',
    precision: 2,
    affixesStay: false,
    thousands: ''
    })

$(document).on 'click', 'a.rejection_button', ->
  dScheduleId = $(this).attr('data-schedule-id')
  dStatus = $(this).attr('data-status')
  $("#exchange_order_schedule_id").val(dScheduleId)
  $("#exchange_order_status").val(dStatus)

$(document).on 'click', 'button#submit_rejection', ->
  $('#rejection_form').submit()
  $('#myModalReject').modal('hide')

# Habilita popovers
$('[data-toggle="popover"]').popover()