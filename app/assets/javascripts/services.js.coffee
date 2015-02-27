# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.controle').each ->
    elem = $(this);
    preco = $("#service_preco")
    fidel = $("#service_recompensa_fidelidade")
    divul = $("#service_recompensa_divulgacao")
    #Save current value of element
    elem.data('oldVal', elem.val());

    #Look for changes in the value
    elem.bind "propertychange change click keyup input paste", ->
      #If value has changed...
      if (elem.data('oldVal') != elem.val())
        #Updated stored value
        elem.data('oldVal', elem.val());

        if(preco.val() != "" && preco.val() != "R$ 0.00" && fidel.val() != "" && divul.val() != "")
          precoVal = parseFloat(preco.val())
          fidelVal = parseInt(fidel.val())
          divulVal = parseInt(divul.val())

          tempoMin = Math.ceil(preco / (fidel))
          tempoMinFidel = Math.ceil(preco / (fidel + divul))

          update_sim_div(tempoMin, tempoMinFidel, precoVal, fidelVal, divulVal)
        else
          $("#sim").empty()        

update_sim_div = (tempoMin, tempoMinFidel, preco, fidel, divul) ->
  $("#sim").empty()
  $("#sim").append("
    <h4>Cenário 1: Cliente nunca fará divulgação</h4>
    Recompensa Ganha: #{fidel} Safiras (equivalente a R$ #{(fidel*0.25).toFixed(2)})<br />
    Safiras suficientes para troca: após #{Math.ceil(preco / (fidel*0.25))} retornos
    <h4>Cenário 2: Cliente sempre fará divulgação</h4>
    Recompensa Ganha: #{divul+fidel} Safiras (equivalente a R$ #{((divul+fidel)*0.25).toFixed(2)})<br />
    Safiras suficientes para troca: após #{Math.ceil(preco / ((divul+fidel)*0.25))} retornos
    ")