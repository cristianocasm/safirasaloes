# == Schema Information
#
# Table name: prices
#
#  id                    :integer          not null, primary key
#  descricao             :string(255)
#  preco                 :decimal(8, 2)
#  recompensa_divulgacao :integer
#  service_id            :integer
#  created_at            :datetime
#  updated_at            :datetime
#

require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  before { subject.stubs(:preco_fixo?).returns(false) }

  should have_many(:schedules)
  should belong_to(:service)
  should validate_presence_of(:descricao).with_message('^Informe uma descrição para cada Preço')
  # should validate_presence_of(:preco)
  should validate_numericality_of(:preco).is_greater_than(0).with_message(I18n.t('price.deve_ser_positivo'))
  should validate_numericality_of(:recompensa_divulgacao).only_integer.is_greater_than_or_equal_to(0).allow_nil.with_message(I18n.t('price.recompensa_deve_ser_positivo_ou_zero'))
  # Não consegui fazer o teste abaixo
  # should validate_uniqueness_of(:descricao).scoped_to(:service_id)

  test "Cadastro - Quando não informado, define recompensa_divulgação = 0" do
    price = prices(:corte_masculino_aline).attributes.except('id')
    price = Price.new(price)
    price.descricao = "Curto"
    price.recompensa_divulgacao = nil
    price.save
    assert price.persisted?, "Preço não persistido"
    assert_equal 0, price.recompensa_divulgacao, "recompensa_divulgacao não definida como zero"
  end

  test "Atualização - Quando não informado, define recompensa_divulgação = 0" do
    price = prices(:corte_masculino_aline)
    price.update(recompensa_divulgacao: nil)
    assert price.persisted?, "Preço não persistido"
    assert_equal 0, price.recompensa_divulgacao, "recompensa_divulgacao não definida como zero"
  end

  test "price.nome retorna nome do serviço quando preço fixo" do
    price = prices(:corte_masculino_aline)
    assert_equal price.service.nome, price.nome
  end

  test "price.nome retorna nome do serviço seguido da descrição do preço quando preço é variável" do
    skip('A ser feito')
    # price = prices(:corte_masculino_aline)
    # assert_equal price.service.nome, price.nome
  end

end
