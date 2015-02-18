json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :professional_id, :customer_id, :service_id, :hora
  json.url schedule_url(schedule, format: :json)
end
