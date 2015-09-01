class Group < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  validates :title, :topics, :starts_at, :ends_at, :venue, :max_members, presence: true
  validates :title, :topics, length: {minimum: 10}
  validates_datetime :ends_at, after: :starts_at
  validates :max_members, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 2,
                                          less_than: 1000  }
end
