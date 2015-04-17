# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# jQuery ->
#   $('#new_photo_log').fileupload
#     dataType: "script"
#     add: (e, data) ->
#       types = /(\.|\/)(gif|jpe?g|png|tiff)$/i
#       file = data.files[0]
#       if types.test(file.type) || types.test(file.name)
#         #if file.size <= 4000000
#         data.context = $(tmpl("template-upload", file))
#         $('#new_photo_log').append(data.context)
#         data.submit()
#         #else
#           #alert("#{file.name} é maior que 4MB")
#       else
#         alert("#{file.name} não é um arquivo gif, jpeg, png ou tiff")
#     progress: (e, data) ->
#       if data.context
#         progress = parseInt(data.loaded / data.total * 100, 10)
#         data.context.find('.progress-bar').each ->
#           me = $(this)
#           me.css('width', progress + '%')
#           me.text(progress + '%');
jQuery ->
  window.locale = 'fileupload':
    'errors':
      'maxFileSize': 'Arquivo é muito grande'
      'minFileSize': 'Arquivo é muito pequeno'
      'acceptFileTypes': 'Foto não é do tipo: jpg, jpeg, png, tiff, gif'
      'maxNumberOfFiles': 'Número máximo de fotos atingido'
      'uploadedBytes': 'Bytes carregados excedem o tamanho do arquivo'
      'emptyResult': 'Arquivo vazio'
    'error': 'Erro'
    'start': 'Enviar'
    'cancel': 'Cancelar'
    'destroy': 'Deletar'

  # Initialize the jQuery File Upload widget:
  $('#fileupload').fileupload(
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.progress-bar').each ->
          me = $(this)
          me.css('width', progress + '%')
          me.text(progress + '%');
    )
  # Load existing files:
  $.getJSON $('#fileupload').prop('action'), (files) ->
    fu = $('#fileupload').data('blueimpFileupload')
    template = undefined
    console.log files
    fu._adjustMaxNumberOfFiles(-files.length)
    template = fu._renderDownload(files).appendTo($('#fileupload .files'))
    # Force reflow:
    fu._reflow = fu._transition and template.length and template[0].offsetWidth
    template.addClass 'in'
    $('#loading').remove()