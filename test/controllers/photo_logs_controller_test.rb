require 'test_helper'

class PhotoLogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "deve ser redirecionado para 'Meus Serviços' caso não possa enviar fotos" do
    @customer = customers(:fernanda)
    sign_in :customer, @customer

    get :new
    assert_redirected_to customer_root_path
    assert_equal "Você não foi atendido por um profissional nas últimas 12 horas e, por isso, ainda não pode enviar fotos.", flash["error"]
  end
  
  context "cliente atendido há menos de 12 horas" do
    setup do
      @customer = customers(:cristiano)
      sign_in :customer, @customer
    end

    should "deve ser capaz de acessar 'Enviar Fotos' caso tenha sido atendido" do
      get :new
      assert_response :success
    end

    context "cliente enviando fotos" do
      setup do
        @image = fixture_file_upload('image.jpg', 'image/jpg')
        @description = 'Testing'
        @schedule = @customer.schedules_not_more_than_12_hours_ago.first

        @photo = {
                  description: @description,
                  schedule_id: @schedule.id,
                  image: @image
                 }
      end

      should "fotos são salvas" do
        assert_difference('PhotoLog.count') do
          xhr :post, :create, photo_log: @photo
        end
      end

      should "parâmetros das fotos são salvos corretamente " do
        xhr :post, :create, photo_log: @photo

        assert_equal assigns(:photoLog).description, @description
        assert_equal assigns(:photoLog).schedule_id, @schedule.id
        assert_equal assigns(:photoLog).customer_id, @customer.id
        assert_equal assigns(:photoLog).image_file_name, @image.original_filename
        assert_equal assigns(:photoLog).image_content_type, @image.content_type
      end
    end

    should "cliente sem permissões dadas não envia fotos para Facebook" do
      Customer.any_instance.stubs(:gave_fb_permissions?).returns(false)
      PhotoLogsController.any_instance.expects(:post).never
      
      xhr :post, :send_to_fb
    end

    context "com permissão dada" do
      setup do
        Customer.any_instance.stubs(:gave_fb_permissions?).returns(true)
      end

      should "cliente com permissões dadas envia fotos para Facebook" do
        images = [mock(), mock(), mock()]
        images.each { |img| img.expects(:submit_to_fb).returns(img) }
        PhotoLog.stubs(:not_posted).returns(images)
        Customer.any_instance.stubs(:get_rewards_by).returns(10)
        
        xhr :post, :send_to_fb
      end

      context "" do
        setup do
          @customer = customers :cristiano_com_integracao
          sign_in :customer, @customer
          Koala::Facebook::API.any_instance.stubs(:put_picture).returns({})
        end

        should "fotos postadas devem ter 'posted' setado como 'true'" do
          @images = get_photo_logs(@customer)
          PhotoLog.stubs(:not_posted).returns(@images)
          xhr :post, :send_to_fb
          @images.each { |img| assert img.posted, "posted != true" }
        end

        should "ao postar fotos, cliente deve ser recompensado caso informações do profissional tenha sido inseridas" do
          @images = get_photo_logs(@customer)
          PhotoLog.stubs(:not_posted).returns(@images)
          sc = @customer.schedules_not_more_than_12_hours_ago.first

          assert_difference(-> { @customer.rewards.where(professional_id: sc.professional_id).first.total_safiras }, sc.service.recompensa_divulgacao) do
            xhr :post, :send_to_fb
          end
        end
        
        should "ao postar fotos, cliente não deve ser recompensado caso informações do profissional não tenham sido inseridas ou tenham sido modificadas" do
          @images = get_photo_logs(@customer)
          PhotoLog.stubs(:not_posted).returns([@images[0]])
          sc = @customer.schedules_not_more_than_12_hours_ago.first

          assert_no_difference(-> { @customer.rewards.where(professional_id: sc.professional_id).first.total_safiras }) do
            xhr :post, :send_to_fb
          end
        end

        should "ao postar fotos, não deve ser recompensado caso já tenha sido" do
          sc = @customer.schedules_not_more_than_12_hours_ago.first
          Schedule.any_instance.stubs(:recompensa_fornecida).returns(true)

          assert_no_difference(-> { @customer.rewards.where(professional_id: sc.professional_id).first.total_safiras }, sc.service.recompensa_divulgacao) do
            xhr :post, :send_to_fb
          end
        end

      end

    end
  end
end

def get_photo_logs(ct)
  pl1 = ct.photo_logs.new(image: fixture_file_upload('image.jpg', 'image/jpg'),
                           description: 'Testing1',
                           schedule_id: ct.schedules_not_more_than_12_hours_ago.first.id)
  pl2 = ct.photo_logs.new(image: fixture_file_upload('image2.jpg', 'image/jpg'),
                           description: 'Testing2',
                           schedule_id: ct.schedules_not_more_than_12_hours_ago.first.id)
  pl3 = ct.photo_logs.new(image: fixture_file_upload('image3.jpg', 'image/jpg'),
                           description: ct.schedules_not_more_than_12_hours_ago.first.professional.contact_info + 'Testing3',
                           schedule_id: ct.schedules_not_more_than_12_hours_ago.first.id)
  images = [pl1, pl2, pl3]
end