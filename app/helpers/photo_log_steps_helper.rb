module PhotoLogStepsHelper

  def submit_to_fb_button
    if can_submit_to_fb?
      concat(
        link_to(next_wizard_path(photos: params[:photos]), class: 'btn btn-block btn-success') do
          concat content_tag(:i, nil, class: 'fa fa-diamond')
          concat content_tag(:i, nil, class: 'fa fa-diamond')
          concat content_tag(:i, nil, class: 'fa fa-diamond')
          concat content_tag(:span, ' QUERO MINHAS SAFIRAS AGORA!!! ', class: 'bold')
          concat content_tag(:i, nil, class: 'fa fa-diamond')
          concat content_tag(:i, nil, class: 'fa fa-diamond')
          concat content_tag(:i, nil, class: 'fa fa-diamond')
        end
      )
    end
  end

  def prof_info_step
    icon = get_prof_info_icon

    concat(
      content_tag(:span) do 
        concat content_tag(:i, nil, class: "fa fa-#{icon[:icon]}-circle fa-3x", style: "color: #{icon[:color]}")
      end
    )
    concat content_tag(:span, 'Informações do Profissional Inseridas', class: 'bold', style: "font-size: 33px")
    unless (@prof_info_allowed == "true")
      concat(
        content_tag(:div) do
          concat(
            content_tag(:em) do
              concat 'Para receber as recompensas você deve inserir as informações de contato do profissional na descrição de cada foto.'
              concat tag(:br)
              concat 'Clique no botão abaixo para voltar ao passo onde essas informações podem ser adicionadas a sua postagem:'
              concat tag(:br)
              concat(
                link_to(wizard_path(:professional_info, photos: params[:photos]), class: 'btn btn-block btn-primary') do
                  concat content_tag(:i, nil, class: 'fa fa-tty')
                  concat content_tag(:span, ' OK! Me Deixe Corrigir Isso!')
                end
              )
            end
          )
        end
      )
    end
  end
  
  def fb_permission_step
    icon = get_fb_permission_icon

    concat(
      content_tag(:span) do 
        concat content_tag(:i, nil, class: "fa fa-#{icon[:icon]}-circle fa-3x", style: "color: #{icon[:color]}")
      end
    )
    concat content_tag(:span, 'Permissão Concedida no Facebook', class: 'bold', style: "font-size: 33px")
    unless current_customer.gave_fb_permissions?
      concat(
        content_tag(:div) do
          concat(
            content_tag(:em) do
              concat 'Para receber as recompensas você deve postar as fotos no seu Facebook.'
              concat tag(:br)
              concat 'Mas não se preocupe! Nós faremos isso por você. Basta que você nos dê sua permissão clicando no botão abaixo:'
              concat tag(:br)
              concat content_tag(:span, 'Atenção! ', class: 'bold')
              concat 'Ao clicar no botão abaixo você será redirecionado para o Facebook para que as devidas permissões sejam concedidas.'
              concat tag(:br)
              concat content_tag(:span, 'Certifique-se de clicar em "OK"', class: 'bold')
              concat " quando perguntado se deseja que o SafiraSalões publique no Facebook por você."
              concat tag(:br)
            end
          )
          concat(
            link_to(customer_omniauth_authorize_path(:facebook), class: 'btn btn-block btn-primary') do
              concat content_tag(:i, nil, class: 'fa fa-facebook-official')
              concat content_tag(:span, ' OK! Publique Minhas Fotos!')
            end
          )
        end
      )
    end
  end

  private

  def can_submit_to_fb?
    current_customer.gave_fb_permissions? && @prof_info_allowed == "true"
  end

  def get_fb_permission_icon
    fbPerm = current_customer.gave_fb_permissions?
    fbPerm ? { icon: 'check', color: 'green' } : { icon: 'times', color: 'red'}
  end

  def get_prof_info_icon
    (@prof_info_allowed == "true") ? { icon: 'check', color: 'green' } : { icon: 'times', color: 'red'}
  end

end