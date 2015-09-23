class Group < ActiveRecord::Base
  belongs_to :user
  has_many :members,  class_name: 'GroupMembership', dependent: :destroy
  has_many :users, through: :group_memberships, foreign_key: 'user_id'
  validates :group_name, :topics, :starts_at, :ends_at, :venue, :max_members, :privacy, presence: true
  validates :group_name, :topics, length: {minimum: 10}
  validates_inclusion_of :privacy, in: %w( public private closed )
  validates_datetime :ends_at, after: :starts_at
  validates :max_members, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 2,
                                          less_than: 1001  }
  validates_numericality_of :latitude, :longitude
  validates :gmap_zoom,  numericality: { only_integer: true,
                                         greater_than_or_equal_to: 1,
                                         less_than_or_equal_to: 21 }
end
