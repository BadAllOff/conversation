class Meeting < ActiveRecord::Base
  validates :title, :topics, :starts_at, :ends_at, :venue, :max_members, presence: true
end
