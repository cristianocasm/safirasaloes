module ServicesHelper
  # Cria link para adição de novos campos para uma dada associação.
  # Utilizado em models com accepts_nested_attributes_for
  def link_to_add_fields(f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, hide_optionals: false)
    end
    link_to('#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")}) do
      concat(
        content_tag(:span) do
          concat(content_tag(:i, '', class: "fa fa-plus") do
            concat(content_tag(:span, 'Adicionar Novo Preço', class: "ml-5"))
          end)
        end
      ) 
    end
  end

  def delete_price_div(f, hide_optionals)
    price = f.object
    scheduled = price.schedules.present?
    persisted = price.persisted?

    generate_div_for_price_deletion(f, hide_optionals, scheduled, persisted)
  end

  private

  def generate_div_for_price_deletion(f, hide_optionals, scheduled, persisted)
    concat(content_tag(:div, '', delete_price_div_options(hide_optionals)) do
            concat(content_tag(:div, '') do
              concat(link_for_price_deletion(f, scheduled, persisted))
            end)
          end
        )
  end

  def delete_price_div_options(hide_optionals)
    if hide_optionals
      { class: 'form-group optional', style: 'display:none;' }
    else
      { class: 'form-group optional' }
    end
  end

  def link_for_price_deletion(f, scheduled, persisted)
    if scheduled
      content_tag(:div, '', style: 'font-style: italic; color: #f5b22a;' )
    else
      hiddenField = f.hidden_field(:_destroy)

      link = link_to('#', class: "remove_fields") do
        concat(content_tag(:span) do
          concat(content_tag(:i, '', class: 'fa fa-trash fa-2x mr-5'))
        end)
      end

      hiddenField + link
    end
  end

end
