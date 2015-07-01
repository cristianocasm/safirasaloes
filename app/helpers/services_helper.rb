module ServicesHelper
  # Cria link para adição de novos campos para uma dada associação.
  # Utilizado em models com accepts_nested_attributes_for
  def link_to_add_fields(f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("preco_variavel_fields", f: builder)
    end
    link_to('#', class: "add_fields btn btn-warning", style: 'margin: 4em', data: {id: id, fields: fields.gsub("\n", "")}) do
      yield
    end
  end

  # Cria um radio button com data-fields e data-prices sendo data-fields
  # o atributo html que levará os campos necessários à criação de um preço
  # fixo para um determinado serviço. Já data-prices leva o preço cadastrado
  # para aquele serviço.
  def radio_button_to_add_fixed_price_fields(f, association)
    radio_button_to_add_fields(f, association, true) do |new_object|
      f.fields_for(association, new_object) { |builder| render('preco_fixo_fields', f: builder) }
    end
  end

  # Cria um radio button com data-fields e data-prices sendo data-fields
  # o atributo html que levará os campos necessários à criação de preços
  # para um determinado serviço. Já data-prices leva os preços cadastrado
  # para aquele serviço.
  def radio_button_to_add_multiple_price_fields(f, association)
    radio_button_to_add_fields(f, association, false) do |new_object|
      link_to_add_fields f, association do
                  concat(
                    content_tag(:span) do
                      concat(content_tag(:i, '', class: "fa fa-plus") do
                        ' Definir Novo Preço'
                      end)
                    end) 
                end
    end
  end

  # Cria radio_buttons para escolha de preço variável ou fixo
  def radio_button_to_add_fields(f, association, preco_fixo)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    data = get_prices_and_fields(f, preco_fixo) { yield(new_object) }

    f.radio_button(
        :preco_fixo,
        preco_fixo,
        data:
          {
            id: id,
            fields: data[:fields].try(:gsub, "\n", ""),
            prices: data[:prices].try(:gsub, "\n", ""),
          }
      )
  end

  # Cria atributos 'data-price' e 'data-fields'.
  # 'data-price' leva os preços já cadastrados para um serviço, caso
  # este já tenha sido salvo.
  # 'data-fields' leva os campos necessários ao cadastro de preços.
  def get_prices_and_fields(f, preco_fixo)
    obj = f.object
    prices = insert_price_fields(f, preco_fixo) if ( (obj.persisted? || obj.errors.present?) && ( obj.preco_fixo == preco_fixo ) )
    fields = yield unless obj.persisted? && obj.preco_fixo && preco_fixo
    { prices: prices, fields: fields }
  end

  # Caso service já tenha sido persistido (portanto formulário de service está
  # sendo utilizado para edição), então campos de preço são criados. Caso contrário,
  # não.
  def insert_price_fields(f, preco_fixo)
    partial = preco_fixo ? 'preco_fixo_fields' : 'preco_variavel_fields'
    if f.object.persisted?
      f.fields_for(:prices, f.object.prices_ordered) { |builder| render partial, f: builder }
    else
      f.fields_for(:prices) { |builder| render partial, f: builder }
    end
  end

  def insert_fields(f, preco_fixo, association)
    if f.object.persisted?
      insert_price_fields(f, preco_fixo)
    else
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      partial = preco_fixo ? 'preco_fixo_fields' : 'preco_variavel_fields'
      f.fields_for(association, new_object, child_index: id) do |builder|
        render(partial, f: builder)
      end
    end
  end
end
