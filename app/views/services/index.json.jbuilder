json.array!(@services) do |service|
  json.extract! service, :id, :nome, :preco, :recompensa_divulgacao
  json.url service_url(service, format: :json)
end
