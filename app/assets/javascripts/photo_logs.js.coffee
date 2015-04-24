# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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
    downloadTemplateId: null
    uploadTemplateId: null
    start: (e) -> $("#loadingModal").modal('show')
    stop: (e) -> post_on_facebook()
    uploadTemplate: (o) -> generateUploadTemplate(o)
    downloadTemplate: (o) -> generateDownloadTemplate(o)
    # progressall: (e, data) ->
    #   if data.context
    #     progress = parseInt(data.loaded / data.total * 100, 10)
    #     data.context.find('.progress-bar').each ->
    #       me = $(this)
    #       me.css('width', progress + '%')
    #       me.text(progress + '%')
    submit: (e, data) ->
      inputs = data.context.find(':input')
      # if inputs.filter((->
      #     !@value and $(this).prop('required')
      #   )).first().focus().length
      #   data.context.find('button').prop 'disabled', false
      #   return false
      data.formData = inputs.serializeArray()
      return
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.progress-bar').each ->
          me = $(this)
          me.css('width', progress + '%')
          me.text(progress + '%')
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png|tiff)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        $.blueimp.fileupload.prototype.options.add.call(this, e, data);
        #if file.size <= 4000000
        #$("#fileupload").fileupload("send", {files: data.files});
        #data.context = $(tmpl("template-upload", file))
        #$('#new_photo_log').append(data.context)
        #data.submit()
        #else
          #alert("#{file.name} é maior que 4MB")
      else
        alert("#{file.name} não é um arquivo gif, jpeg, png ou tiff")
    )

  # Load existing files:
  load_existing_files()

load_existing_files = ->
  $("#loadingPageModal").modal('show')
  $("div.container").show()
  $.getJSON $('#fileupload').prop('action'), (files) ->
    if files.length > 0 then post_on_facebook() else $("#loadingPageModal").modal('hide')
    fu = $('#fileupload').data('blueimpFileupload')
    template = undefined
    fu._adjustMaxNumberOfFiles(-files.length)
    template = fu._renderDownload(files).appendTo($('#fileupload .files'))
    # Force reflow:
    fu._reflow = fu._transition and template.length and template[0].offsetWidth
    template.addClass 'in'
    $('#loading').remove()

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
    row.find('.name').text file.description
    rows = rows.add(row)
  rows

post_on_facebook = ->
  $("#loadingPageModal").modal('hide')
  $("#loadingModal").modal('show')
  $.ajax
    url: "/cliente/photo_logs/send_to_fb",
    type: 'post'
    success: (data, textStatus, jqXHR) ->
      if data.permissaoDada && data.fotosPostadas
        console.log "Entrei"
        window.location.href = "/cliente?photo_sent=true"
      else
        console.log "Entrei2"
        $("#loadingPageModal").modal('hide')
        $("#loadingModal").modal('hide')
        $("#fbModal").modal('show')
    error: (jqXHR, textStatus, errorThrown) ->
      alert("Um erro inesperado impediu suas fotos de serem enviadas para o Facebook. Atualize a página para tentar novamente.")

generateResultButton = (file) ->  
  if file.posted
    "<td class='delete' style='vertical-align: middle;'><button class='btn btn-primary' disabled><i class='fa fa-facebook-official'></i><span> Postado com Sucesso</span></button></td>"
  else
    "<td class='delete' style='vertical-align: middle;'><button class='btn btn-danger' data-type='#{file.delete_type}' data-url='#{file.delete_url}'><i class='fa fa-trash'></i><span> Não Postado no Facebook (Excluir)</span></button></td>"

generateUploadTemplate = (o) ->
  rows = $()
  $.each o.files, (index, file) ->
    row = $('' +
      '<tr class="template-upload fade">' +
      '<td class="preview" style="vertical-align: middle;"><span class="fade"></span></td>' +
      '<td class="name" style="display:none"></td>' +
      '<td class="size" style="display:none"></td>' +
      '<td class="comment" style="vertical-align: middle;"><span><textarea class="form-control input-sm" name="photo_log[description]" required cols="500" placeholder="Esta foto será postada em seu Facebook. Escreva aqui o que você deseja que seus amigos vejam."></textarea></span></td>' +
      '<td class="comment" style="display:none;"><input type="text" name="photo_log[schedule_id]" class="schedule_id" required value="' + $("#photo_log_schedule_id").val() + '"></input></td>' +
      content(file, o, index) +
      cancel_button(index) +
      '</tr>' +
      '<tr>' +
      '<td colspan="4" class="test" style="border-top: none !important">' +
      '<div class="progress progress-animated progress-striped active" style="padding=0px; margin-top: 0px !important; width: 100%;">' +
      '<div class="progress-bar progress-bar-success" style="width:0%;"></div>' +
      '</div>' +
      '</td>' +
      '</tr>')
    row.find('.name').text file.name
    row.find('.size').text o.formatFileSize(file.size)
    if file.error
      row.find('.error').text file.error
    rows = rows.add(row)
  $("button.start").show() if o.files.length > 0
  rows

content = (file, o, index) ->
  if file.error
    "<td class='error' colspan='2'><span class='label label-important'>#{locale.fileupload.error}</span> #{locale.fileupload.errors[file.error] || file.error}</td>"
  else if o.files.valid && !index && !o.options.autoUpload
    "<td class='start' style='display: none'><button>#{locale.fileupload.start}</button></td>"
  else
    "<td colspan='2'></td>"

cancel_button = (index) ->
  if !index
    "<td class='cancel' style='vertical-align: middle;'><button class='btn btn-warning'><i class='fa fa-ban'></i><span> #{locale.fileupload.cancel}</span></button></td>"