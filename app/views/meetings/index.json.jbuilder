json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :title, :topics, :starts_at, :ends_at, :venue, :max_members
  json.url meeting_url(meeting, format: :json)
end
