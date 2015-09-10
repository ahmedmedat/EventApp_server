json.array!(events) do |event|
  json.extract! event, :id, :name, :description, :location, :date, :username
  json.url event_url(event, format: :json)
end
