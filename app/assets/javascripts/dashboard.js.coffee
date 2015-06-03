# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if $("#bar-chart").length
    build_bottle_neck_graph()

build_bottle_neck_graph = ->
  $.ajax
    url: "/admin/taken_steps"
    type: 'put'
    dataType: "json"
    success: (data, textStatus, jqXHR) ->
      plot(data)
    error: (jqXHR, textStatus, errorThrown) ->
      alert("Não foi possível recuperar as informações para a geração dos gráficos.")

plot = (data) ->
  $.plot($("#bar-chart"), data[1], {
    legend:
      noColumns: 8
    series:
      stack: false,
      lines: { show: false, fill: true, steps: false },
      bars: { show: true, fill: true, fillColor: { colors: [ { opacity: 0.9 }, { opacity: 0.8 } ] } }
    bars: 
      barWidth: 0.7
      fill: true
      align: "center"
    grid:
      borderWidth: 0, hoverable: true, color: "#777"
    xaxis:
      mode: "time",
      tickSize: [1, "day"],
      ticks: data[0]
      tickLength: 10,
      color: "black",
      axisLabel: "Data",
      axisLabelUseCanvas: true,
      axisLabelFontSizePixels: 12,
      axisLabelFontFamily: 'Verdana, Arial',
      axisLabelPadding: 5
    yaxis:
      axisLabel: "Último Passo Dado",
      axisLabelUseCanvas: true,
      axisLabelFontSizePixels: 12,
      axisLabelFontFamily: 'Verdana, Arial',
      axisLabelPadding: 20
  })