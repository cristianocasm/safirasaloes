class ProfessionalApprovedWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  # Envia e-mail de convite para profissional informando-o
  # de que sua participação no SafiraSalões foi aprovada
  # e que ele pode agora utilizar o sistema.
  # @prNome - Nome do profissional que marcou o horário
  # @dataInicio - Data do horário marcado
  # @horaInicio - Hora inicial do horário marcado
  # @email - E-mail do cliente ainda não cadastrado
  # @serviceNome - Nome do serviço que será fornecido pelo profissional ao cliente
  # @registrationURL - URL no qual cliente será habilitado a fazer seu cadastro
  def perform
    mandrill = Mandrill::API.new(ENV["MANDRILL_PASSWORD"]).messages
    templateName = "professional_approved"
    async = true

    emails.each do |contact|
      message = generate_message(contact)
      puts mandrill.send_template(templateName, nil, message, async)
    end
  end

  private

  def generate_message(contact)
    {
      from_email: "contato@safirasaloes.com.br",
      from_name: "SafiraSalões",
      subject: "Sua Participação no SafiraSalões foi...",
      to: [ { email: contact[:email] } ],
      track_opens: true,
      track_clicks: true,
      inline_css: true,
      preserve_recipients: false,
      tracking_domain: 'stats.safirasaloes.com.br',
      merge: true,
      merge_vars: [ {
                      rcpt: contact[:email],
                      vars: [ { name: 'nome', content: contact[:nome].titleize } ]
                    }
                  ]
    }
  end

  def emails
    [
      {:nome=>"lilian", :email=>"lilianrj40@hotmail.com"},
      {:nome=>"ana paula", :email=>"studiodepaula@hotmail.com.br"},
      {:nome=>"Fernanda Sant'Anna ", :email=>"f.s.oliveira90@gmail.com"},
      {:nome=>"luciana", :email=>"lucianacandido81@gmail.com"},
      {:nome=>"Almir júnior", :email=>"almirjunior7@hotmail.com"},
      {:nome=>"bruno", :email=>"debussimans@hotmail.com"},
      {:nome=>"ayana lima", :email=>"ayana.l@hotmail.com"},
      {:nome=>"claudia", :email=>"ferreiradacostac@gmail.com"},
      {:nome=>"Eliane Alves ", :email=>"ea-lira2011@hotmail.com"},
      {:nome=>"Maria   claudenir", :email=>"claudiasantos852@gmail.com"},
      {:nome=>"António cledson", :email=>"cledson.s@hotmail.com"},
      {:nome=>"Rogeria", :email=>"Rogeria2210@gmail.com"},
      {:nome=>"tTon Fernandes ", :email=>"tonfernandes25@outlook.com"},
      {:nome=>"MAURO TRAJANO DA SILVA", :email=>"maurotrajano@hotmail.com"},
      {:nome=>"Jeferson Vasconcelos ", :email=>"jeefvasconcelos25@gmail.com"},
      {:nome=>"Liliez Cristine", :email=>"liliez.cris@hotmail.com"},
      {:nome=>"Aidan Gonzaga", :email=>"aidanide1982@hotmail.com"},
      {:nome=>"Fernanda ", :email=>"f.s.oliveira90@gmail.com"},
      {:nome=>"vani", :email=>"vvaninhaanjos@hotmail.com"},
      {:nome=>"EDVALDO ", :email=>"edvaldo_dantas@ig.com.br"},
      {:nome=>"luzia", :email=>"luziadeoliveiraherneque@gmail.com"},
      {:nome=>"Douglas", :email=>"financeirodobalc@yahoo.com.br"},
      {:nome=>"Elionai da Silva Codonio", :email=>"elisilco@gmail.com"},
      {:nome=>"JOSE DIOMARIO GONÇALVES DE OLIVEIRA", :email=>"ALBERT_4035@HOTMAIL.COM"},
      {:nome=>"mara silva", :email=>"marasilva.maia3@gmail.com"},
      {:nome=>"luciana", :email=>"lucian.anobom@hotmail.com"},
      {:nome=>"Ana Carla", :email=>"carlinha.jnreal@gmail"},
      {:nome=>"joice", :email=>"joicesilvadourado01@gmail.com"},
      {:nome=>"rafaiane", :email=>"rafaianemichele@hotmail.com"},
      {:nome=>"Marco Antonio", :email=>"marco.directinfo@sercomtel.com.br"},
      {:nome=>"Graça", :email=>"m.gracadeoliveira@gmail.com"},
      {:nome=>"Celina", :email=>"lilibonates@yahoo.com.br"},
      {:nome=>"Cristiane", :email=>"crishairebeauty14@gmail.com"},
      {:nome=>"ROSANGELA", :email=>"ROSANGELA.SINTONIADABELA@HOTMAIL.COM"},
      {:nome=>"Diego", :email=>"diegosanti1@gmail.com"},
      {:nome=>"lindenaide", :email=>"lindaoliv62@gmail.com"},
      {:nome=>"Anna Paula", :email=>"tresjolieinstituto@gmail.com"},
      {:nome=>"Kelly", :email=>"kellyfabiportie@gmail.com"},
      {:nome=>"Nicole", :email=>"cibelesantiagoigd@hotmail.com"},
      {:nome=>"Eliana", :email=>"elianacross@bol.com.br"},
      {:nome=>"jaqueline", :email=>"jackgiardini@yahoo.com.br"},
      {:nome=>"Jay J ferreira", :email=>"joenny.corey@live.com"},
      {:nome=>"Ana Paula", :email=>"paulabelcorpcosmeticos@gmail.com"},
      {:nome=>"nedi machado", :email=>"needi_machado@hotmail.com"},
      {:nome=>"kellen", :email=>"freitas.kellen@hotmail.com"},
      {:nome=>"Ivonete", :email=>"elisama_evangelista@hotmail.com"},
      {:nome=>"erimarc", :email=>"erimarchairstyler@hotmail.com"},
      {:nome=>"Willian", :email=>"wllferreira6@gmail.com"},
      {:nome=>"pricila", :email=>"Elvisferry@hotmail.com.br"},
      {:nome=>"Priscila", :email=>"celsogomes_07@hotmail.com"},
      {:nome=>"Déo Junior", :email=>"deoblack@hotmail.com"},
      {:nome=>"Magda", :email=>"magdaf.b.fernandes@gmail.cim"},
      {:nome=>"cris", :email=>"cterezasantos@gmail.com"},
      {:nome=>"Sandra", :email=>"Sadraelisapatracao@hotmail.com"},
      {:nome=>"franciele", :email=>"francielyy30@hotmail.com"},
      {:nome=>"naldy", :email=>"naldygata@hotmail.com"},
      {:nome=>"leuza", :email=>"leuzaporcelana@gmail.com"},
      {:nome=>"Josefa", :email=>"Jorara2013@Gmail.com"},
      {:nome=>"Gisele", :email=>"gihalves87@gmail.com"},
      {:nome=>"JACK", :email=>"jacksplr@hotmail.com"},
      {:nome=>"Maria", :email=>"elyzabet-fff@hotmail.com"},
      {:nome=>"marina", :email=>"marinaflorinda01@gmail.com"},
      {:nome=>"Andréa", :email=>"andreaazevedodesouza.aads@gmail.com"},
      {:nome=>"Hélio", :email=>"weverblak29@gmail.com"},
      {:nome=>"juliana", :email=>"aluizbrindes@outlook.com"},
      {:nome=>"nadia", :email=>"nadiaandrade22@hotmail.com"},
      {:nome=>"alex", :email=>"alexevaristo30@gmail.com"},
      {:nome=>"benakya", :email=>"nayy.cabeleleira@hotmail.com"},
      {:nome=>"alex", :email=>"alex_teffy@hotmail.com"},
      {:nome=>"renato", :email=>"renato.dubai@hotmail.com"},
      {:nome=>"Jessika", :email=>"jessikassouza10@gmail.com"},
      {:nome=>"Marina", :email=>"marinaalves9669@gmail.com"},
      {:nome=>"julielba", :email=>"julielba77@hotmail.com"},
      {:nome=>"Rosana", :email=>"rosanaartezanato2011@hotmail.com"},
      {:nome=>"eliane", :email=>"eliane1987alveslima@hotmail.com"},
      {:nome=>"Giovanna", :email=>"giovanna.ayumi@live.com"},
      {:nome=>"Emmanuelle", :email=>"mannusilvamacedo@gmail.com"},
      {:nome=>"Ana", :email=>"acsa.alves112@gmail.com"},
      {:nome=>"paulo", :email=>"sergioqueirozcabelo@gmail.com"},
      {:nome=>"vanete", :email=>"vanete_gui@hotmail.com"},
      {:nome=>"Reisla Jones", :email=>"reisla.jones@gmail.com"},
      {:nome=>"pricila", :email=>"anapricilaaraujo@gmail.com"},
      {:nome=>"ivanilda", :email=>"ivanilda.fashion@hotimail.com.br"},
      {:nome=>"Paula", :email=>"Paulas2marlon@hotmail.com"},
      {:nome=>"thaiz", :email=>"thaizlorenzo@hotmail.com"},
      {:nome=>"Caroline ", :email=>"karol_bruno.henri@hotmail.com"},
      {:nome=>"jurutania", :email=>"salaotaniaqueiroz@gmail.com"},
      {:nome=>"ADRIANA", :email=>"drikhair@hotmail.com"},
      {:nome=>"ludiMila ", :email=>"ludinhaborges@hotmail.com"},
      {:nome=>"Robson", :email=>"robsonmoro@gmail.com"},
      {:nome=>"adelita", :email=>"adelitadasilva56@gmail.com"},
      {:nome=>"Sunday Dias", :email=>"sundaydias@ig.com.br"},
      {:nome=>"jessica", :email=>"jessicakekasan@hotmail.com"},
      {:nome=>"ESPAÇO EXCLUSIVO", :email=>"lras20@ig.com.br"},
      {:nome=>"CRISTIANE", :email=>"CRISLUNELLI@HOTMAIL.COM"},
      {:nome=>"alex sandro", :email=>"gatin.1993@gmai.com"},
      {:nome=>"VANESSA", :email=>"nessapassos_ka@hotmail.com"},
      {:nome=>"Maria Rosa", :email=>"mary_rosa36@hotmail.com"},
      {:nome=>"Nick", :email=>"petenussonick@hotmail.com"},
      {:nome=>"SALÃO MODELO cabelo e corpo", :email=>"oziel.gigante@gmail.com"},
      {:nome=>"Audrey", :email=>"audikc30@gmail.com"},
      {:nome=>"laodileia", :email=>"yuri06rocha@hotmail.com"},
      {:nome=>"CLEIDE", :email=>"cleideas@bol.com.br"},
      {:nome=>"jones", :email=>"jonesbaroll@hotmail.com"},
      {:nome=>"Marilene", :email=>"marilene.rs@uol.com.br"},
      {:nome=>"luzia", :email=>"herneque@gmail.com"},
      {:nome=>"lucas", :email=>"lik_borges@hotmail.com"},
      {:nome=>"josiane", :email=>"salao.mulherbrasileira.beleza@gmail.com"},
      {:nome=>"julia", :email=>"juliacristinafinanceiro@ig.com.br"},
      {:nome=>"Liliane ", :email=>"liliematheus93@gmail.com"},
      {:nome=>"gislaine", :email=>"gislaine.oliveira1984@hotmail.com"},
      {:nome=>"Valeria", :email=>"lela_gg@hotmail.com"},
      {:nome=>"Susana", :email=>"souza.susana@yahoo.com.br"},
      {:nome=>"adriana", :email=>"adrianafamili22@hotmail.com"},
      {:nome=>"Vanessa", :email=>"vanessafrancisco@revelar.me"},
      {:nome=>"larissa", :email=>"lalaxonada@hotmail.com"},
      {:nome=>"natalia", :email=>"naty986@bol.com.br"},
      {:nome=>"rosiane", :email=>"rosibsilva@hotmail.com"},
      {:nome=>"Maysa", :email=>"ysinhalindinha748@gmail.com"},
      {:nome=>"werlisson", :email=>"Werlissonnascimento22@gmail.com"},
      {:nome=>"claudeane", :email=>"claudeanefrancisca@yahoo.com"},
      {:nome=>"jessica", :email=>"katarina1938@live.com"},
      {:nome=>"Rute", :email=>"ruthe.sueli@gmail.com"},
      {:nome=>"ANDREZA", :email=>"andreza.yasminsilva@gmail.com"},
      {:nome=>"camila", :email=>"caamila_caarla@hotmail.com"},
      {:nome=>"RICARDO ", :email=>"djavanconsultoria@gmail.com"},
      {:nome=>"Madalena", :email=>"magsilvagoveia2013@gmeil.com"},
      {:nome=>"weber", :email=>"weberlucca9@hotmail.com"},
      {:nome=>"Cicera", :email=>"paulaseccogracia@hotmail.com"}
    ]
  end
end