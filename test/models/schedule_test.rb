# == Schema Information
#
# Table name: schedules
#
#  id                   :integer          not null, primary key
#  professional_id      :integer
#  customer_id          :integer
#  service_id           :integer
#  datahora_inicio      :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  datahora_fim         :datetime
#  safiras_resgatadas   :integer          default(0)
#  nome                 :string(255)
#  email                :string(255)
#  telefone             :string(255)
#  pago_com_safiras     :boolean          default(FALSE)
#  recompensa_fornecida :boolean          default(FALSE)
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  include MailerMacros

  should belong_to(:professional)
  should belong_to(:customer)
  should belong_to(:service)
  should_not have_db_column(:recompensa_divulgacao)
  should have_db_column(:nome)
  should have_db_column(:email)
  should have_db_column(:telefone)
  should have_many(:photo_logs)
  should validate_presence_of(:professional_id)
  should validate_presence_of(:service_id)
  should validate_presence_of(:datahora_inicio)
  
  before do
    reset_email
  end

  describe "Cadastro" do
    test "inválido sem nome, telefone ou e-mail do cliente" do
      sc = schedules(:invalido_sem_cli_info).attributes
      sc = Schedule.new(sc)
      assert_not sc.valid?
      assert_equal [:base], sc.errors.keys
      assert_equal ["Informe Nome e/ou Email e/ou Telefone do cliente"], sc.errors.messages[:base]
    end

    test "salva email em caixa baixa" do
      sc = schedules(:valido_com_cli_info).attributes.except('id')
      sc['email'] = sc['email'].titleize
      sc = Schedule.new(sc)
      assert sc.save
      assert_not_equal sc.email, schedules(:valido_com_cli_info).email.titleize
      assert_equal sc.email, schedules(:valido_com_cli_info).email.downcase
    end

    test "invoca 'deal_with_safiras_acceptance' se pago_com_safiras=true" do
      sc = schedules(:valido_com_cli_info).attributes.except('id')
      sc['pago_com_safiras'] = true
      Schedule.any_instance.expects(:deal_with_safiras_acceptance)
      Schedule.new(sc).save
    end
    
    describe "com 'customer_id' presente" do
      before do
        @sc = schedules(:valido_com_cli_info).attributes.except('id')
        @sc = Schedule.new(@sc)
      end

      # test "define 'recompensa_divulgacao' como service.recompensa" do
      #   @sc.save
      #   assert_equal @sc.service.recompensa_divulgacao, @sc.recompensa_divulgacao, 'Não definindo recompensa_divulgacao'
      # end
    
      test "é válido com 'e-mail' selecionado e envia e-mail de notificação" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.any_instance.stubs(:perform).returns({})
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "não envia e-mails com 'e-mail' inválido" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.email = "asdf"
        @sc.save
        assert !@sc.valid?, "Objeto considerado válido"
      end

      test "não envia e-mails com 'e-mail' vazio" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.email = ""
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end
    end

    describe "com 'customer_id' não refletindo e-mail selecionado" do
      before do
        @sc = schedules(:valido_com_cli_info).attributes.except('id')
        @sc['customer_id'] = customers(:cristiano).attributes['id']
        @sc = Schedule.new(@sc)
      end

      test "com e-mail válido (pertencente a cliente cadastrado) envia e-mail de notificação" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.any_instance.stubs(:perform).returns({})
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "com e-mail válido (pertencente a cliente cadastrado) redefine 'customer_id'" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.any_instance.stubs(:perform).returns({})
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
        assert_equal @sc.customer_id, schedules(:valido_com_cli_info).customer_id
        assert_not_equal @sc.customer_id, customers(:cristiano).id
      end

      test "com e-mail válido, mas não pertencente a cliente algum envia e-mail convite" do
        NotificationWorker.expects(:perform).never
        InvitationWorker.any_instance.stubs(:perform).returns({})
        @sc.email = "asdf@test.com.br"
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "com e-mail válido, mas não pertencente a cliente algum limpa 'customer_id'" do
        skip("Adiando solução deste problema")
        NotificationWorker.expects(:perform).never
        @sc.email = "asdf@test.com.br"
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
        assert_nil @sc.customer_id
      end

      test "não envia e-mails com 'e-mail' inválido" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.email = "asdf"
        @sc.save
        assert !@sc.valid?, "Objeto considerado válido"
      end

      test "não envia e-mails com 'e-mail' vazio" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.email = ""
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end
    end
  end

  describe "Atualização" do
    describe "com 'customer_id' presente" do
      before do
        @sc = schedules(:valido_com_cli_info)
      end

      test "inválida sem nome, telefone ou e-mail do cliente" do
        @sc.nome = ""
        @sc.email = ""
        @sc.telefone = ""
        @sc.save
        assert_not @sc.valid?, "Objeto considerado válido"
        assert_equal [:base], @sc.errors.keys, "Erro base não adicionado"
        assert_equal ["Informe Nome e/ou Email e/ou Telefone do cliente"], @sc.errors.messages[:base], "Mensagem de erro não adicionada"
      end

      test "notifica cliente por e-mail se 'e-mail' for alterado" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.any_instance.stubs(:perform).returns({})
        ct = customers(:cristiano)
        @sc.email = ct.email
        @sc.customer_id = ct.id
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "envia e-mail de notificação se serviço mudar" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.any_instance.stubs(:perform).returns({})
        @sc.service_id = services(:corte_feminino_aline).id
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "envia e-mail de notificação se início mudar" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.any_instance.stubs(:perform).returns({})
        @sc.datahora_inicio = @sc.datahora_inicio - 1.day
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "envia e-mail de notificação se fim mudar" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.any_instance.stubs(:perform).returns({})
        @sc.datahora_fim = @sc.datahora_fim + 30.days
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "não envia e-mails se apenas nome mudar" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.nome = "teste"
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "não envia e-mail se apenas telefone mudar" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.telefone = '(31) 1234-5678'
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      test "não envia e-mails com 'e-mail' inválido" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.email = "asdf"
        @sc.save
        assert !@sc.valid?, "Objeto considerado válido"
      end

      test "não envia e-mails com 'e-mail' vazio" do
        InvitationWorker.expects(:perform).never
        NotificationWorker.expects(:perform).never
        @sc.email = ""
        @sc.save
        assert @sc.valid?, "Objeto considerado inválido"
      end

      describe "com e-mail divergente do customer_id" do
        test "para cliente não cadastrado envia e-mail convite" do
          NotificationWorker.expects(:perform).never
          InvitationWorker.any_instance.stubs(:perform).returns({})
          @sc.email = "abc_test@gmail.com"
          @sc.save
          assert @sc.valid?, "Objeto considerado inválido"
        end

        test "para cliente cadastrado envia e-mail convite" do
          InvitationWorker.expects(:perform).never
          NotificationWorker.any_instance.stubs(:perform).returns({})
          ct = customers(:cristiano)
          @sc.email = ct.email
          @sc.save
          assert @sc.valid?, "Objeto considerado inválido"
        end
      end
    end
  end
end

# == Plano de Teste para Schedules
#   Cliente
#     - Marcação de Horário
#       - Cliente cadastrado?
#         - Não envia e-mail
#       - Cliente não cadastrado?
#         - Recompensa de fidelidade para o serviço?
#           - E-mail de convite falando sobre o que ele ganhou
#         - Sem recompensa de fidelidade?
#           - Recompensa de Divulgação?
#             - E-mail de convite alertando sobre Safira de Divulgação
#           - Sem recompensa de Divulgação?
#             - Não envia e-mail

#---
#   - Nome, email e telefone na seleção de cliente (todos com autopreenchimento e, quando selecionado o cliente, demais campos são preenchidos)
#   - Cliente não informado exibe mensagem de erro
#   - Seleção de cliente e Seleção de outro deve alterar informações do formulário corretamente
# Service
#   - Serviço não informado retorna mensagem de erro correta
#   - datahora_inicio não informada retorna mensagem de erro correta
#   - datahora_fim não informada retorna mensagem de erro correta
#   - datahora_fim deve ser igual ou superior à datahora_inicio
#   - datahora_inicio deve ser igual ou superior a hoje

#---
# Erros no schedule
#   Horários
#     Início anterior ao presente momento
#     Início após Fim / Fim antes de Início
#     Não é data
#     Início não informado
#     O que acontece com fim não informado?
#     Cenários: Criação e Atualização

#   Serviços
#     Serviço não informado
#     Serviço não existente

#   Profissional
#     Não informado
