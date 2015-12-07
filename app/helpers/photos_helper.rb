module PhotosHelper

  def get_fb_parameters_for_sharing_button(photo, on_site = false)
    params = {
      method: 'feed',
      link: professionals_site_url(@professional),
      picture: "#{ENV['HOST_URL']}#{photo.image.url}",
      name: @professional.nome.titleize,
      caption: @professional.endereco,
      description: "Marque seu horário: #{@professional.telefone} - #{@professional.whatsapp}",
      photo_id: photo.id
    }

    params.tap do |p|
      unless on_site
        ci = photo.customer_invitation
        p[:link] = p[:link] + "?v=#{ci.validation_token}" unless ci.validation_token.blank?
        p[:telefone] = ci.customer_telefone
        p[:recompensar] = true
      end
    end
  end

  def generate_gallery
    concat(content_tag(:ul, id: 'gallery') do
      @photos.each do |photo|
        concat(content_tag(:li, class: 'mix category-people') do # category-* é utilizado para filtragem
          concat(content_tag(:div, class: 'gallery-item rounded shadow') do
            
            concat(button_tag(class: "gallery-love rounded fb-enjoy btn", data: get_fb_parameters_for_sharing_button(photo, true)) do
              concat(content_tag(:i, ' Compartilhar', class: 'fa fa-facebook-official', style: 'display: inline'))
            end)

            concat(content_tag(:a, href: "javascript:void(0);", class: "gallery-img") do
              concat(image_tag(photo.image.url, class: "img-responsive full-width", style: 'border: 2px solid #81b71a;'))
            end)

            concat(content_tag(:div, class: "gallery-details") do
              concat(content_tag(:div, class: "gallery-summary") do
                concat(content_tag(:p, photo.description))
              end)
            end)

            if @professional.avatar_url.present?
              concat(content_tag(:div, class: 'gallery-author') do
                concat(content_tag(:div, class: 'media') do
                  
                  concat(content_tag(:div, class: 'media-left') do
                    concat(content_tag(:a, href: '#') do
                      concat(image_tag(@professional.avatar_url, class: 'media-object img-circle'))
                    end)
                  end)

                  concat(content_tag(:div, class: 'media-body') do
                    concat(content_tag(:h4, @professional.nome.titleize, class: 'media-heading text-capitalize'))
                    # concat(content_tag(:span, @professional.profissoes, class: 'text-capitalize'))
                  end)

                end)
              end)
            end

          end)
        end)
      end
    end)
  end

  def generate_popover
    byebug
    ci = current_customer.customer_invitations.where("invitation_status_id = ?", InvitationStatus.find_by_nome('visto').id)
  end

  # def generate_send_photo_step(f)
  #   case @can_send_photo
  #   when :yes; generate_photo_form(f)
  #   when :future; generate_wait_screen
  #   when :past; generate_try_next_time_screen
  #   when :no; generate_no_schedule_screen
  #   end
  # end

  # def generate_revision_step
    
  #   concat(content_tag(:div, class: 'sign-header no-padding') do
  #     concat(content_tag(:div, class: 'form-group') do
  #       concat(content_tag(:div, class: 'sign-text-without-before italic') do
  #         concat(get_professional_avatar)
  #         concat(content_tag(:p, style: 'text-transform: none') do
  #           concat(content_tag(:strong, @ctNome.titleize))
  #           concat(get_main_msg)
  #         end)
  #         concat(content_tag(:p, fb_permission_link))
  #       end)
  #     end)
  #   end)

  # end


  # private


  # private

  # def generate_photo_form(f)
  #   concat(content_tag(:div, class: 'sign-header no-padding') do
  #     concat(content_tag(:div, class: 'form-group') do
  #       concat(content_tag(:div, class: 'sign-text-without-before italic') do
  #         concat(get_professional_avatar)
          
  #         concat(content_tag(:p, style: 'text-transform: none;') do
  #           concat("Ótimas notícias, ")
  #           concat(content_tag(:strong, @ctNome.titleize))
  #           concat("!")
  #         end)

  #         concat(content_tag(:p, style: 'text-transform: none;', class: 'no-margin') do
  #           concat("A partir de agora você poderá ")
  #           concat(content_tag(:strong, 'acumular pontos'))
  #           concat(" e ")
  #           concat(content_tag(:strong, "trocar por meus serviços"))
  #           concat(" sempre que agendar um horário!")
  #         end)

  #         concat(content_tag(:p) do
  #           concat(content_tag(:button, 'Conheça as regras', type: 'button', class: 'btn btn-danger btn-block rounded', 'data-toggle' => 'modal', 'data-target' => '#myCustomerCarouselModal'))
  #         end)

  #       end)
  #     end)
  #   end)

  #   # The loading indicator is shown during image processing
  #   concat(content_tag(:div, class: 'form-group col-sm-12') do
  #     concat(content_tag(:div, '', class: 'fileupload-loading'))
  #     concat(tag(:br))
  #   end)

  #   # The table listing the files available for upload/download
  #   concat(content_tag(:div, class: 'form-group col-sm-12') do
  #     concat(content_tag(:table, class: 'table table-striped') do
  #       concat(content_tag(:tbody, '', class: 'files', 'data-toggle' => 'modal-gallery', 'data-target' => '#modal-gallery'))
  #     end)
  #   end)

  #   concat(content_tag(:div, class: 'sign-footer') do
  #     concat(content_tag(:div, class: 'form-group') do
  #       concat(content_tag(:span, class: 'btn btn-warning btn-lg btn-block rounded col-sm-12 fileinput-button') do
  #         concat(content_tag(:i, '', class: 'fa fa-plus'))
  #         concat(content_tag(:span, ' Escolher Fotos...'))
  #         concat(f.file_field :image, multiple: true, name: 'photo_log[image]', class: 'col-sm-12', style: 'height: 100%; padding: 0px;')
  #       end)
  #     end)
  #   end)

  # end

  # def generate_wait_screen
  #   concat(content_tag(:div, class: 'sign-header no-padding') do
  #     concat(content_tag(:div, class: 'form-group') do
  #       concat(content_tag(:div, class: 'sign-text-without-before italic') do
  #         concat(get_professional_avatar)
          
  #         concat(content_tag(:p, style: 'text-transform: none;') do
  #           concat("Ótimas notícias, ")
  #           concat(content_tag(:strong, @ctNome.titleize))
  #           concat("!")
  #         end)

  #         concat(content_tag(:p, style: 'text-transform: none;', class: 'no-margin') do
  #           concat("A partir de agora você poderá ")
  #           concat(content_tag(:strong, 'acumular pontos'))
  #           concat(" e ")
  #           concat(content_tag(:strong, "trocar por meus serviços"))
  #           concat(" sempre que agendar um horário!")
  #         end)

  #         concat(content_tag(:p) do
  #           concat(content_tag(:button, 'Conheça as regras', type: 'button', class: 'btn btn-danger btn-block rounded', 'data-toggle' => 'modal', 'data-target' => '#myCustomerCarouselModal'))
  #         end)

  #         concat(content_tag(:p, "*Volte após o agendamento para participar - a partir de #{@schedule.datahora_fim.strftime('%d/%m/%Y às %H:%M')}", style: 'text-transform: none;'))
  #       end)
  #     end)
  #   end)

  # end
  
  # def generate_try_next_time_screen
  #   concat(content_tag(:div, class: 'sign-header no-padding') do
  #     concat(content_tag(:div, class: 'form-group') do
  #       concat(content_tag(:div, class: 'sign-text-without-before italic') do
  #         concat(get_professional_avatar)
          
  #         concat(content_tag(:p, style: 'text-transform: none;') do
  #           concat("Ótimas notícias, ")
  #           concat(content_tag(:strong, @ctNome.titleize))
  #           concat("!")
  #         end)

  #         concat(content_tag(:p, style: 'text-transform: none;', class: 'no-margin') do
  #           concat("A partir de agora você poderá ")
  #           concat(content_tag(:strong, 'acumular pontos'))
  #           concat(" e ")
  #           concat(content_tag(:strong, "trocar por meus serviços"))
  #           concat(" sempre que agendar um horário!")
  #         end)

  #         concat(content_tag(:p) do
  #           concat(content_tag(:button, 'Conheça as regras', type: 'button', class: 'btn btn-danger btn-block rounded', 'data-toggle' => 'modal', 'data-target' => '#myCustomerCarouselModal'))
  #         end)

  #         concat(content_tag(:p, "*O prazo para participar era até #{(@schedule.datahora_fim+12.hours).strftime('%d/%m/%Y às %H:%M')}. Mas não se preocupe! Da próxima vez, acesse o link enviado para seu celular até 12 horas após o atendimento.", style: 'text-transform: none;'))
  #       end)
  #     end)
  #   end)

  # end

  # def generate_no_schedule_screen
  #   concat(content_tag(:div, class: 'sign-header no-padding') do
  #     concat(content_tag(:div, class: 'form-group') do
  #       concat(content_tag(:div, class: 'sign-text-without-before italic') do
          
  #         concat(content_tag(:p, style: 'text-transform: none;') do
  #           concat("Ótimas notícias!")
  #         end)

  #         concat(content_tag(:p, style: 'text-transform: none;', class: 'no-margin') do
  #           concat("A partir de agora você poderá ")
  #           concat(content_tag(:strong, 'acumular pontos'))
  #           concat(" e ")
  #           concat(content_tag(:strong, "trocar por meus serviços"))
  #           concat(" sempre que agendar um horário!")
  #         end)

  #         concat(content_tag(:p, "*Para participar acesse o outro link enviado para seu celular. Caso você tenha desmarcado o horário, nenhuma mensagem será enviada.", style: 'text-transform: none;'))
  #       end)
  #     end)
  #   end)
  # end

  # def get_professional_avatar
  #   tag(:img, src: @professional.avatar_url, class: "img-circle", alt: @professional.nome) if @professional.avatar_url.present?
  # end


  # ######################################################
  # # Funcões abaixo são destinadas à geração do front-end
  # # do último passo ('revision') para divulgação no FB.
  # ######################################################

  # def fb_permission_link
  #   link_to("/auth/facebook?scope=publish_actions&action=publish_photos&#{@photos.map(&:id).to_query('photos')}&schedule=#{@sc}", class: 'btn btn-block btn-primary normal-white-space') do
  #     concat content_tag(:i, nil, class: 'fa fa-facebook-official')
  #     concat content_tag(:span, get_text_for_fb_permission_link)
  #   end
  # end

  # def get_text_for_fb_permission_link
  #   if @prof_info_allowed == "true"
  #     ' OK! Publique Minhas Fotos!'
  #   else
  #     ' OK! Adicione seu Contato e Publique Minhas Fotos!'
  #   end
  # end

  # def get_main_msg
  #   if @prof_info_allowed == "true"
  #     ', falta só um passo! Publique suas fotos no Facebook pra ganhar as recompensas'
  #   else
  #     ', para receber as recompensas é necessário que minhas informações de contato sejam adicionadas à sua publicação'
  #   end
  # end
end