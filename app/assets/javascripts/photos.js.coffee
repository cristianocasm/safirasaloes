# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if $("form#fileupload").length && fileInputSupported()
    # load_existing_files()
    initialize_calculators()
    initialize_fileupload_plugin()
    set_possible_errors()
    validate_form_on_submit()
    # config_carousel()

validate_form_on_submit = ->
  $("#fileupload").submit (e) ->
    validate_fields()

initialize_calculators = ->
  $('form .recompensa').each (i, e) ->
    initialize_calculator(e)

initialize_calculator = (e) ->
  $(e).TouchSpin(
    postfix: "equivale a R$ 0.00 em descontos"
    min: 0
    max: 1000000000
  )

  activate_calculator(e)

  $(e).bind 'propertychange change click keyup input paste', (event) ->
    activate_calculator(e)

activate_calculator = (e) ->
  saf = $(e).val().match(/\d+/)
  saf == null ? 0 : saf[0]
  cred = parseFloat(saf / 2).toFixed(2)
  calc = $(e).siblings("span.bootstrap-touchspin-postfix")
  calc.text("equivale a R$ #{cred} em descontos")
  calc.bind 'click', (event) ->
    $(e).focus()

# generate_mobile_caption = ->
#   content = $("div.active div.carousel-caption").html()
#   content = "" if content == undefined
#   $("#content-for-mobile").html(content)

# config_carousel = ->
#   $("#myCustomerCarouselModal").bind "show.bs.modal", ->
#     generate_mobile_caption()
#   $("#customer_carousel").on 'slid.bs.carousel', (e) ->
#     generate_mobile_caption() if $("#content-for-mobile").is(":visible")

# Detect file input support - Reference: http://bit.ly/1G9PyLc
fileInputSupported = ->
  isFileInputSupported = do ->
    # Handle devices which falsely report support
    if navigator.userAgent.match(/(Android (1.0|1.1|1.5|1.6|2.0|2.1))|(Windows Phone (OS 7|8.0))|(XBLWP)|(ZuneWP)|(w(eb)?OSBrowser)|(webOS)|(Kindle\/(1.0|2.0|2.5|3.0))/)
      return false
    # Create test element
    el = document.createElement('input')
    el.type = 'file'
    !el.disabled
  # Add 'fileinput' class to html element if supported
  if isFileInputSupported
    $("#create_photo_form").removeClass('hidden')
    return true
  else
    alert "Infelizmente seu dispositivo é incapaz de enviar fotos para o SafiraSalões.\n\n
    Mas nem tudo está perdido :D\n\n
    Você pode tentar novamente utilizando um outro celular, computador, tablet ou navegador."
    return false

# load_existing_files = ->
#   $.getJSON $('#fileupload').prop('action'), (files) ->
#     fu = $('#fileupload').data('blueimpFileupload')
#     template = undefined
#     fu._adjustMaxNumberOfFiles(-files.length)
#     template = fu._renderDownload(files).appendTo($('#fileupload .files'))
#     # Force reflow:
#     fu._reflow = fu._transition and template.length and template[0].offsetWidth
#     template.addClass 'in'
#     $('#loading').remove()

initialize_fileupload_plugin = ->
  $('#fileupload').fileupload
    downloadTemplateId: null
    uploadTemplateId: null
    uploadTemplate: (o) -> generateUploadTemplate(o)
    add: (e, data) ->
      $.blueimp.fileupload.prototype.options.add.call(this, e, data) # ativa template de upload
      $('button#send').click ->
        $('button#send').attr('disabled', 'disabled')
        $('button#send').html("<i class='fa fa-send-o'></i> Convidando Cliente a Divulgar...")
        if validate_fields()
          if data.context.is(':visible') # segunda instrução verifica se foto não foi deletada
            data.context.find('td.cancel, td.loading').remove()
            data.context = data.context.append('<td style="vertical-align: middle; min-width: 7em;" class="loading"><div class="progress progress-success progress-striped active"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div></td>')
            data.submit()
        else
          $('button#send').removeAttr('disabled')
          $('button#send').html("<i class='fa fa-send-o'></i> Enviar Para Cliente Divulgar")
        false # retorna falso para evitar submissão do formulário
    done: (e, data) ->
      id = data.result.files[0].id
      data.context.append("<input name='invitation[photo_ids][]' value='#{id}' type='hidden'></input>")
    stop: (e) ->
      $("#fileupload").submit()
      $('button#send').attr('disabled', '')
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.progress-bar').each ->
          progress = 99 if progress == 100
          me = $(this)
          me.css('width', progress + '%')
          me.text(progress + '%')

validate_fields = ->
  valid = true
  if $("#invitation_customer_telefone").val() == ""
    valid = false
    $("#invitation_customer_telefone_error").show()
  else
    $("#invitation_customer_telefone_error").hide()
  
  if $("td.preview").length == 0
    valid = false
    $("#insert_photo_error").show()
  else
    $("#insert_photo_error").hide()

  valid

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

generateUploadTemplate = (o) ->
  rows = $()
  $.each o.files, (index, file) ->
    row = $('' +
      '<tr class="template-upload fade">' +
      '<td class="preview" align="center" style="vertical-align: middle;"><span class="fade"></span></td>' +
      content(file, o, index) +
      cancel_button(index) +
      '</tr>')
    rows = rows.add(row)
  $('.hidden').removeClass('hidden') if rows.length > 0
  rows

content = (file, o, index) ->
  if file.error
    "<td class='error'><span class='label label-important'>#{locale.fileupload.error}</span> #{locale.fileupload.errors[file.error] || file.error}</td>"
  else if o.files.valid && !index
    '<td style="vertical-align: middle;" class="loading"></td>'

cancel_button = (index) ->
  if !index
    "<td class='cancel' style='vertical-align: middle;'><button class='btn btn-danger btn-lg rounded'><i class='fa fa-trash'></i></button></td>"