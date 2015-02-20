json.array!(@rewards) do |reward|
  json.extract! reward, :id, :service_id, :quantidade_safiras
  json.url reward_url(reward, format: :json)
end
