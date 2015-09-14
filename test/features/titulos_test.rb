require "test_helper"

feature "Títulos" do
  before do
    skip("Sem foco") if !metadata[:focus] && ENV['focus'] == 'true'
    skip("Evitando JS") if metadata[:js] && ENV['js'] == 'false'
  end

  feature "Páginas Externas" do
    scenario "login - profissional" do
      visit new_professional_session_path
      assert page.has_title? 'Entrar | SafiraSalões'
    end

    scenario "solicitar alteração de senha - profissional" do
      visit new_professional_password_path
      assert page.has_title? 'Solicitar Troca de Senha | SafiraSalões'
    end

    scenario "alterar senha - profissional" do
      visit edit_professional_password_path(reset_password_token: 'test_token123')
      assert page.has_title? 'Alterar Senha | SafiraSalões'
    end

    scenario "cadastrar - profissional" do
      visit new_professional_registration_path
      assert page.has_title? 'Cadastrar | SafiraSalões'
    end

    # scenario "instruções de confirmação" do
    #   visit new_professional_confirmation_path
    #   assert page.has_title? 'Reenviar Instruções | SafiraSalões'
    # end

    scenario "login - cliente" do
      visit new_customer_session_path
      assert page.has_title? 'Entrar | SafiraSalões'
    end

    scenario "solicitar alteração de senha - cliente" do
      visit new_customer_password_path
      assert page.has_title? 'Solicitar Troca de Senha | SafiraSalões'
    end

    scenario "alterar senha - cliente" do
      visit edit_customer_password_path(reset_password_token: 'test_token123')
      assert page.has_title? 'Alterar Senha | SafiraSalões'
    end

    scenario "cadastrar - cliente" do
      ci = customer_invitations(:convite)
      visit new_customer_registration_path(customer: { email: ci.email, token: ci.token })
      assert page.has_title? 'Cadastrar | SafiraSalões'
    end

    scenario "política de privacidade" do
      visit politica_privacidade_path
      assert page.has_title? 'Política de Privacidade | SafiraSalões'
    end

    scenario "login - admin" do
      visit new_admin_session_path
      assert page.has_title? 'Acesso Restrito | SafiraSalões'
    end

    # scenario "solicitar alteração de senha - admin" do
    #   visit new_admin_password_path
    #   assert page.has_title? 'Alterar Senha | SafiraSalões'
    # end

    # scenario "alterar senha - admin" do
    #   visit edit_admin_password_path
    #   assert page.has_title? 'Alterar Senha | SafiraSalões'
    # end
  end

  feature "Páginas Internas" do
    feature "Profissional" do
      before do
        @profAline = professionals('aline')
        login_as @profAline, :scope => :professional
      end

      scenario "dados de contato" do
        visit edit_professional_registration_path(@profAline)
        assert page.has_title? 'Dados de Contato | SafiraSalões'
      end

      scenario "minha agenda" do
        visit professional_root_path
        assert page.has_title? 'Divulgador | SafiraSalões'
      end

      scenario "meus serviços" do
        visit services_path
        assert page.has_title? 'Meus Serviços | SafiraSalões'
      end

      scenario "cadastrar serviço" do
        visit new_service_path
        assert page.has_title? 'Cadastrar Serviço | SafiraSalões'
      end

      scenario "editar serviço" do
        visit edit_service_path(@profAline.services.first)
        assert page.has_title? 'Editar Serviço | SafiraSalões'
      end

      scenario "consultar serviço" do
        visit service_path(@profAline.services.first)
        assert page.has_title? 'Consultar Serviço | SafiraSalões'
      end

      scenario "minha agenda" do
        visit new_schedule_path
        assert page.has_title? 'Divulgador | SafiraSalões'
      end
    end

    feature "Cliente" do
      before do
        @customer = customers(:cristiano)
        login_as(@customer, :scope => :customer)
      end

      scenario "serviços por profissionais" do
        visit customer_root_path
        assert page.has_title? 'Meus Serviços e Profissionais | SafiraSalões'
      end

      scenario "enviar fotos", js: true do
        visit new_photo_log_path
        assert page.has_title? 'Enviar Fotos | SafiraSalões'

        within("#fileupload") do
          attach_file('photo_log_image', '/home/cristiano/Imagens/Cristiano.jpg', visible: false)
        end
        
        # Força aplicação a aguardar pelo carregamento total da foto
        page.find_button('Excluir')
        click_link "Próximo Passo"

        # Definir Comentários
        assert_equal photo_log_step_path(id: 'comments'), page.current_path
        assert page.has_title? 'Comentar Fotos | SafiraSalões'
        click_button "Próximo Passo"

        # Inserir dados do profissional
        assert_equal photo_log_step_path(id: 'professional_info'), page.current_path
        assert page.has_title? 'Inserir Dados do Profissional | SafiraSalões'
        click_button "Insira por Mim"
        Customer.any_instance.stubs(:gave_fb_permissions?).returns(true)
        click_link "Próximo Passo"

        # Ganhar Recompensa
        assert_equal photo_log_step_path(id: 'revision'), page.current_path
        assert page.has_title? 'Revisão | SafiraSalões'
        click_link "QUERO MINHAS SAFIRAS AGORA!!!"
        assert_equal customer_root_path, page.current_path
      end

      scenario "enviar fotos", focus: true do
        visit photo_log_steps_path
        assert page.has_title? 'Enviar Fotos | SafiraSalões'
      end

      # scenario "obrigado" do
      #   visit retorno_pagamento_path
      #   assert page.has_title? 'Obrigado | SafiraSalões'
      # end
    end

    feature "Admin" do
      before do
        @admin = admins(:admin)
        login_as(@admin, :scope => :admin)
      end

      scenario "dashboard" do
        visit admin_root_path
        assert page.has_title? 'Dashboard | SafiraSalões'
      end
    end
  end

end