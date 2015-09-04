class Group < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  validates :group_name, :topics, :starts_at, :ends_at, :venue, :max_members, :privacy, presence: true
  validates :group_name, :topics, length: {minimum: 10}
  validates_inclusion_of :privacy, in: %w( public private closed )
  validates_datetime :ends_at, after: :starts_at
  validates :max_members, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 2,
                                          less_than: 1001  }
end
