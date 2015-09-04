json.array!(@groups) do |group|
  json.extract! group, :id, :group_name, :topics, :starts_at, :ends_at, :venue, :max_members
  json.url group_url(group, format: :json)
end
