jQuery ->
  if $('#gallery').length
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