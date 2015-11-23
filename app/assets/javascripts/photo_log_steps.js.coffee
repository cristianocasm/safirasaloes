# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/
# jQuery ->
#   if $("#prependProfInfoButton").length
#     $('#prependProfInfoButton').on 'click', prepend_prof_contact_info_to_posting
#     window.profInfoAdded = false

# prepend_prof_contact_info_to_posting = ->
#   $('div.chat-content').each ->
#     elm = $(this)
#     if window.profInfoAdded == false
#       content = prof_info_plus_comment(elm)
#       comment = elm.find('div.chat-content')
#       elm.html(content)
#       elm.append(comment)
#       toggle_contact_info_button("Remova por Mim", "btn-danger", "btn-warning")
#     else
#       toggle_contact_info_button("Insira por Mim", "btn-warning", "btn-danger")
#       elm.find('span.profInfo').remove()
#   window.profInfoAdded = !window.profInfoAdded

# prof_info_plus_comment = (elm) ->
#   profInfo = $("div.prof-info").children().html()
#   comment = elm.html()
#   if comment != ""
#     profInfo += "<br/>---<br/>"
#   return "<span> <span class='profInfo'>#{profInfo}</span>  <span>#{comment}</span> </span>"

# toggle_contact_info_button = (text, addClass, removeClass) ->
#   $("#prependProfInfoButton").text(text)
#   $("#prependProfInfoButton").addClass(addClass)
#   $("#prependProfInfoButton").removeClass(removeClass)