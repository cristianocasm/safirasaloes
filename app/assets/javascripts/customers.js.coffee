# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'submit', 'form#new_customer', ->
  $("#customer_email").prop('disabled', false)
  true