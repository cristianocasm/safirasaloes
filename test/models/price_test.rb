require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  should belong_to(:service)
  should validate_presence_of(:nome)
  should validate_uniqueness_of(:nome).scoped_to(:service_id)
  should validate_presence_of(:preco)
  should validate_numericality_of(:preco).is_greater_than(0)
  should validate_numericality_of(:recompensa_divulgacao).only_integer.is_greater_than_or_equal_to(0).allow_nil

  describe "Criação" do
    test "Quando não informado, define recompensa_divulgação = 0" do
      srv = services(:corte_masculino_aline)
      price = Price.new(nome: 'teste', preco: 100.00, service_id: srv.id)
      price.save
      assert price.persisted?, "Serviço não persistido"
      assert_equal 0, price.recompensa_divulgacao, "recompensa_divulgacao não definida como zero"
    end
  end
end
