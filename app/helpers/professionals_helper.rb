module ProfessionalsHelper
  def nome_profissional
    current_professional.nome
  end

  def professional_widget_title
    case controller_name
    when 'professional_registrations'
      widget_title('tty', 'Dados de Contato')
    when 'services'
      case action_name
      when 'new', 'create'
        widget_title('scissors', 'Cadastrar Serviço')
      when 'edit', 'update'
        widget_title('scissors', 'Editar Serviço')
      when 'index'
        widget_title('scissors', 'Meus Serviços')
      when 'show'
        widget_title('scissors', 'Consultar Serviço')
      end
    when 'schedules'
      widget_title('bullhorn', 'Estimular Cliente a Divulgar Trabalho')
    end
  end

  def professional_widget_subtitle
    case controller_name
    when 'professional_registrations'
      widget_title('tty', 'Informe seu contato para que ele seja divulgado (pelos seus clientes) juntamente com fotos do serviço prestado.')
    when 'services'
      case action_name
      when 'new', 'create'
        widget_title('scissors', 'Cadastre o serviço definindo nome, preço(s) e recompensa(s) por divulgação.')
      when 'edit', 'update'
        widget_title('scissors', 'Altere os campos abaixo e pressione "Salvar" para atualizar o serviço.')
      when 'index'
        widget_title('scissors', 'Cadastre seus serviços para que você possa estimular seus clientes a divulgá-los.')
      when 'show'
        widget_title('scissors', "Veja abaixo os detalhes do serviço #{@service.nome.titleize}.")
      end
    when 'schedules'
      widget_title('bullhorn', 'Informe o cliente e o serviço na agenda abaixo para estimulá-lo a divulgar seu trabalho.')
    end
  end

  def selected(*options)
    concat content_tag(:span, nil, class: 'selected') if options.include? controller_name
  end

  def build_tour_steps
    if @step_taken.nil? || @step_taken
      normal_tour()
    elsif !@step_taken
      bootstrap_tour()
    end
  end

  private

  def widget_title(icon, text)
    concat content_tag :i, nil, class: "fa fa-#{icon}"
    concat " " + text
  end

  def bootstrap_tour
    case controller_name
    when 'professional_registrations'
      professional_registrations_steps
    when 'services'
      case action_name
      when 'new'
        new_service_steps
      when 'show'
        service_steps
      when 'index'
        services_bootstrap_steps
      when 'edit'
        edit_service_steps
      end
    when 'schedules'
      schedule_steps
    end
  end

  def normal_tour
    case controller_name
    when 'professional_registrations'
      professional_registrations_steps
    when 'services'
      case action_name
      when 'new'
        new_service_steps
      when 'show'
        service_steps
      when 'index'
        services_steps
      when 'edit'
        edit_service_steps
      end
    when 'schedules'
      schedule_steps
    end
  end

  def schedule_steps
    {
      name: "schedule_steps",
      steps: [
        {
          orphan: true,
          backdrop: true,
          title: "<i>O boca-a-boca é a melhor divulgação</i><button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          content: "
          <p>O <b>SafiraSalões</b> <b>incentivará</b> seus clientes a <b>divulgar</b> nas redes sociais <b>seu contato profissional</b>\
          juntamente com as <b>fotos</b> do visual <b>criado por você</b>.</p>",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
            <div class='popover-navigation' style='background-color: #c4e2bb'>
              <button class='btn btn-success' data-role='next'>Ótimo! Me mostre como »</button>
            </div>
          </div>"
        },
        {
          element: "button#btn_agendar",
          placement: "top",
          title: "Utilize nossa <b>Agenda</b><button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          content: "
          <p><b>Informe</b> quem é <b>seu próximo cliente</b> e o SafiraSalões irá incentivá-lo a <b>divulgar seu trabalho</b>.</p>",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
            <div class='popover-navigation' style='background-color: #c4e2bb'>
              <button class='btn btn-danger' data-role='prev'>« </button>
              <button class='btn btn-success btn_tour_agendar' data-role='next'>Quero informar cliente »</button>
            </div>
          </div>"
        }
      ],
      backdrop: false,
      keyboard: false,
      template: "
      <div class='popover tour'>
        <div class='arrow'></div>
        <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
        <div class='popover-content'></div>
        <div class='popover-navigation' style='background-color: #c4e2bb'>
          <button class='btn btn-success' data-role='next'> »</button>
          <button class='btn btn-danger' data-role='prev'>« </button>
          <button class='btn btn-default' data-role='end' style='float: none !important;'>x</button>
        </div>
      </div>"
    }.to_json
  end

  def services_steps
    {
      name: "services_steps",
      steps: [
        {
          placement: 'bottom',
          backdrop: false,
          title: "Área de Serviços<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          element: "div.panel",
          content: "
          <p>Esta é a área onde você terá controle total sobre seus serviços.</p>
          <p>Sempre que quiser acessá-la basta procurar pela opção 'Meus Serviços'
          no menu lateral (esquerda).</p>
          ",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
            <div class='popover-navigation' style='background-color: #c4e2bb'>
              <button class='btn btn-success' data-role='next'>Próximo »</button>
            </div>
          </div>"
        },
        {
          placement: 'top',
          title: "Tenha controle sobre seus serviços<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          backdrop: false,
          element: "table#table",
          content: "
          <p>Visualize os serviços cadastrados, os preços e as recompensas. Tudo em um só lugar.</p>
          "
        },
        {
          placement: 'left',
          title: "Gerencie serviços com facilidade <button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          backdrop: false,
          element: "tbody>tr td:last",
          content: "
          <p>Consulte, altere ou exclua seus serviços de maneira muito fácil.</p>
          "
        },
        {
          placement: 'bottom',
          title: "Cadastre novos serviços <button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          backdrop: false,
          element: "a.btn.btn-success.btn-lg",
          content: "
          <p>Cadastre novos serviços clicando em 'Cadastrar Serviço'.</p>
          "
        }
      ],
      backdrop: true,
      keyboard: false,
      template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
            <div class='popover-navigation' style='background-color: #c4e2bb'>
            <button class='btn btn-danger' data-role='prev'>« Anterior</button>
              <button class='btn btn-success' data-role='next'>Próximo »</button>
            </div>
          </div>"
    }.to_json
  end

  def services_bootstrap_steps
    {
      name: "services_bootstrap",
      steps: [
        {
          placement: 'bottom',
          backdrop: false,
          title: "Área de Serviços<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          element: "div.panel",
          content: "
          <p>Esta é a área onde você terá controle total sobre seus serviços.</p>
          <p>Sempre que quiser acessá-la basta procurar pela opção 'Meus Serviços'
          no menu lateral (esquerda).</p>
          ",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
            <div class='popover-navigation' style='background-color: #c4e2bb'>
              <button class='btn btn-success' data-role='next'>Próximo »</button>
            </div>
          </div>"
        },
        {
          placement: 'bottom',
          title: "Criar recompensa para divulgação<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          backdrop: false,
          element: "tbody a.btn-warning:first",
          content: "
          <p><b>Clique no lápis</b> para definir uma recompensa de divulgação para este serviço.</p>
          ",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
          </div>"
        }
      ],
      backdrop: true,
      keyboard: false,
      template: "
      <div class='popover tour'>
        <div class='arrow'></div>
        <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
        <div class='popover-content'></div>
        <div class='popover-navigation' style='background-color: #c4e2bb'>
          <button class='btn btn-success' data-role='next'> »</button>
          <button class='btn btn-danger' data-role='prev'>« </button>
          <button class='btn btn-default' data-role='end' style='float: none !important;'>x</button>
        </div>
      </div>"
    }.to_json
  end

  def edit_service_steps
    {
      name: "edit_schedules_bootstrap",
      steps: [
        {
          placement: 'bottom',
          title: "Criar recompensas<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          element: "div.panel-body",
          content: "
          <p>As recompensas no SafiraSalões são chamadas 'Safiras' e cada Safira equivale
          a R$ 0,50 (50 centavos).</p>
          <p>Defina nos campos acima quantas Safiras você deseja dar como recompensa.</p>
          <p>Não esqueça de informar também o preço do serviço. Caso haja mais de um preço, clique
          no botão 'Adicionar Novo Preço'.</p>
          ",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
          </div>"
        }
      ],
      backdrop: false,
      keyboard: false,
      template: "
      <div class='popover tour'>
        <div class='arrow'></div>
        <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
        <div class='popover-content'></div>
        <div class='popover-navigation' style='background-color: #c4e2bb'>
          <button class='btn btn-success' data-role='next'> »</button>
          <button class='btn btn-danger' data-role='prev'>« </button>
          <button class='btn btn-default' data-role='end' style='float: none !important;'>x</button>
        </div>
      </div>"
    }.to_json
  end

  def service_steps
      {
        name: "service_step",
        steps: [
          {
            placement: 'top',
            title: "Consulte seu Serviço<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
            element: "div.panel-body",
            content: "
            <p>Consulte todas as informações do serviço nesta área.</p>
            <p>Para alterar qualquer informação, clique no botão 'Editar'.</p>
            ",
            template: "
            <div class='popover tour'>
              <div class='arrow'></div>
              <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
              <div class='popover-content'></div>
            </div>"
          }
        ],
        backdrop: false,
        keyboard: false,
        template: "
        <div class='popover tour'>
          <div class='arrow'></div>
          <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
          <div class='popover-content'></div>
          <div class='popover-navigation' style='background-color: #c4e2bb'>
            <button class='btn btn-success' data-role='next'> »</button>
            <button class='btn btn-danger' data-role='prev'>« </button>
            <button class='btn btn-default' data-role='end' style='float: none !important;'>x</button>
          </div>
        </div>"
      }.to_json
  end

  def new_service_steps
    {
      name: "new_service_step",
      steps: [
        {
          placement: 'bottom',
          title: "Cadastre seus Serviços<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          element: "div.panel-body",
          content: "
          <p>Cadastre nesta área seu serviço.</p>
          <p>Clique em 'Adicionar Novo Preço' caso o preço do serviço seja variável e 
          não esqueça de informar uma descrição que justifique a variação.</p>
          <p><b>Informe também um recompensa de divulgação. Assim, você estimula seus
          clientes a divulgar seu trabalho e os fideliza automaticamente.</b></p>
          ",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
          </div>"
        }
      ],
      backdrop: false,
      keyboard: false,
      template: "
      <div class='popover tour'>
        <div class='arrow'></div>
        <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
        <div class='popover-content'></div>
        <div class='popover-navigation' style='background-color: #c4e2bb'>
          <button class='btn btn-success' data-role='next'> »</button>
          <button class='btn btn-danger' data-role='prev'>« </button>
          <button class='btn btn-default' data-role='end' style='float: none !important;'>x</button>
        </div>
      </div>"
    }.to_json
  end

  def professional_registrations_steps
    {
      name: "contact_step",
      steps: [
        {
          placement: 'bottom',
          backdrop: false,
          title: "Defina suas Informações de Contato<button type='button' class='close' data-role='end'><span aria-hidden='true'>&times;</span></button>",
          element: "div.panel-body",
          content: "
          <p>Informe no formulário seus dados de contato.</p>
          <p>Dessa forma, sempre que uma divulgação for feita, seus dados serão
          adicionados a ela e os interessados poderão entrar em contato para
          marcar horários.</p>
          <p><b>Simule uma divulgação clicando em 'Simular Divulgação'</b></p>
          ",
          template: "
          <div class='popover tour'>
            <div class='arrow'></div>
            <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
            <div class='popover-content'></div>
          </div>"
        }
      ],
      backdrop: false,
      keyboard: false,
      template: "
      <div class='popover tour'>
        <div class='arrow'></div>
        <h3 class='popover-title' style='background-color: #c4e2bb'></h3>
        <div class='popover-content'></div>
        <div class='popover-navigation' style='background-color: #c4e2bb'>
          <button class='btn btn-success' data-role='next'> »</button>
          <button class='btn btn-danger' data-role='prev'>« </button>
          <button class='btn btn-default' data-role='end' style='float: none !important;'>x</button>
        </div>
      </div>"
    }.to_json
  end

end