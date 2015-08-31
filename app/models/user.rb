class User < ActiveRecord::Base
  has_many :meetings
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :validatable, password_length: 8..128
  validates :first_name, :last_name, :presence => true
end
