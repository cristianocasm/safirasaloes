# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if $("form#fileupload").length
    load_existing_files()
    initialize_fileupload_plugin()
    set_possible_errors()

load_existing_files = ->
  $.getJSON $('#fileupload').prop('action'), (files) ->
    fu = $('#fileupload').data('blueimpFileupload')
    template = undefined
    fu._adjustMaxNumberOfFiles(-files.length)
    template = fu._renderDownload(files).appendTo($('#fileupload .files'))
    # Force reflow:
    fu._reflow = fu._transition and template.length and template[0].offsetWidth
    template.addClass 'in'
    $('#loading').remove()

initialize_fileupload_plugin = ->
  $('#fileupload').fileupload
    downloadTemplateId: null
    uploadTemplateId: null
    autoUpload: true
    uploadTemplate: (o) -> generateUploadTemplate(o)
    downloadTemplate: (o) -> generateDownloadTemplate(o)
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.progress-bar').each ->
          me = $(this)
          me.css('width', progress + '%')
          me.text(progress + '%')

set_possible_errors = ->
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

generateDownloadTemplate = (o) ->
  rows = $()
  $.each o.files, (i, file) ->
    row = $('' +
      if !file.error
        "<tr class='template-download fade'>" +
        "<td class='preview'><a href='#{file.url}' title='#{file.name}' rel='gallery' download='#{file.name}'><img src='#{file.thumbnail_url}'></a></td>" +
        "<td class='name'></td>" +
        generateResultButton(file) +
        "</tr>"
      )
    row.find('.name').text file.name
    rows = rows.add(row)
  rows

generateUploadTemplate = (o) ->
  rows = $()
  $.each o.files, (index, file) ->
    row = $('' +
      '<tr class="template-upload fade">' +
      '<td class="preview" style="vertical-align: middle;"><span class="fade"></span></td>' +
      '<td class="name"></td>' +
      '<td class="schedule_id" style="display:none;"><input type="text" name="photo_log[schedule_id]"></input></td>' +
      content(file, o, index) +
      cancel_button(index) +
      '</tr>')
    row.find('.name').text file.name
    row.find('.schedule_id input').val($("#photo_log_schedule_id").val())
    rows = rows.add(row)
  rows

generateResultButton = (file) ->  
  if file.posted
    "<td class='delete' style='vertical-align: middle;'><button class='btn btn-primary' disabled><i class='fa fa-facebook-official'></i><span> Postado com Sucesso</span></button></td>"
  else
    "<td class='delete' style='vertical-align: middle;'><button class='btn btn-danger' data-type='#{file.delete_type}' data-url='#{file.delete_url}'><i class='fa fa-trash'></i><span> Excluir</span></button></td>"

content = (file, o, index) ->
  if file.error
    "<td class='error' colspan='2'><span class='label label-important'>#{locale.fileupload.error}</span> #{locale.fileupload.errors[file.error] || file.error}</td>"
  else if o.files.valid && !index
    '<td><div class="progress progress-success progress-striped active"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div></td>'

cancel_button = (index) ->
  if !index
    "<td class='cancel' style='vertical-align: middle;'><button class='btn btn-warning hide_on_step_2 cancel_button'><i class='fa fa-ban'></i><span> #{locale.fileupload.cancel}</span></button></td>"