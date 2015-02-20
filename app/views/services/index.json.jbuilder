json.array!(@services) do |service|
  json.extract! service, :id, :nome, :preco, :hora_duracao, :minuto_duracao
  json.url service_url(service, format: :json)
end
