json.array!(@customers) do |customer|
  json.extract! customer, :id, :nome, :email
  json.url customer_url(customer, format: :json)
end
