json.array!(@photo_logs) do |photo_log|
  json.extract! photo_log, :id, :customer_id, :professional_id, :schedule_id, :service_id, :safiras
  json.url photo_log_url(photo_log, format: :json)
end
