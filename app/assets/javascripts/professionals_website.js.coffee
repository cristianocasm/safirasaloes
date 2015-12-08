jQuery ->
  if $('#gallery').length
    fb_buttons()
    mixitup()

mixitup = ->
  $('#gallery').mixItUp animation:
    animateResizeContainer: false
    duration: 400
    effects: 'fade translateZ(-360px) stagger(34ms)'
    easing: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)'
  setTimeout (->
    $('#gallery').mixItUp 'setOptions', animation: easing: 'ease'
    return
  ), 1000

fb_buttons = ->
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
        $.post('/cliente/assign_rewards_to_customer', { 'photo_id': that.photoId, 'telefone': that.telefone, 'recompensar': that.recompensar }, null, 'script')
        
    FB.ui(obj, callback)