# class PhotoLogStepsController < ApplicationController
#   include Wicked::Wizard
#   steps :comments, :professional_info, :revision
#   layout "login"

#   def show

#     case step; when :comments
#       session[:photo_ids] = params['photos'] if params[:photos]
#     end
    
#     check_photos_inserted_and_recover_parameters
#     notice_woopra() if Rails.env.production?
    
#     render_wizard
#   end
  
#   def update
#     ids = []

#     params["photos"].each do |key, val|
#       # pl = current_customer.photo_logs.find_by_id(key)
      
#       # Fazer dessa forma (ao invés de fazer como acima) cria um problema de segurança
#       # onde qualquer pessoa pode acessar qualquer foto salva em nosso servidor, bastando
#       # para isso que ele altere no navegador os ids das fotos
#       pl = PhotoLog.find_by_id(key)

#       if pl.present?
#         pl.update_attribute(:description, val["description"])
#         ids << key
#       end
#     end

#     redirect_to next_wizard_path(s: params[:s])
#   end

#   private

#   def recover_parameters
#     @sc = session[:schedule_id]
#     @schedule = Schedule.find_by_id(@sc)
#     if @schedule
#       @ctNome = @schedule.nome_cliente
#       @professional = @schedule.professional
#       @can_send_photo = @schedule.can_send_photo?
#       @prof_info = @professional.contact_info # para passo 'professional_info'
#       @prof_info_allowed = params['prof_info_allowed'] # para passo 'revision'
#     end
#   end

#   def check_photos_inserted_and_recover_parameters
#     # # @photos = current_customer.photo_logs.where(id: params['photos'])
    
#     # Fazer dessa forma (ao invés de fazer como acima) cria um problema de segurança
#     # onde qualquer pessoa pode acessar qualquer foto salva em nosso servidor, bastando
#     # para isso que ele altere no navegador os ids das fotos
#     photo_ids = session[:photo_ids]
#     schedule_id = session[:schedule_id]
#     @photos = PhotoLog.find_not_posted_by_ids_and_schedule(photo_ids, schedule_id)
#     if @photos.blank?
#       redirect_to new_photo_log_path, flash: { error: 'Carregue pelo menos 1 foto.' }
#     else
#       recover_parameters
#     end
#   end

#   def notice_woopra
#     woopra = WoopraTracker.new(request)
#     woopra.config( domain: "safirasaloes.com.br" )
#     case params['id']
#     when 'comments'; woopra.track('divulgating', { when: 'durante', step: 1 }, true)
#     when 'professional_info'; woopra.track('divulgating', { when: 'durante', step: 2 }, true) if params['prof_info_allowed'] == 'true'
#     when 'revision'; woopra.track('divulgating', { when: 'durante', step: 3 }, true)
#     end
#   end

# end
