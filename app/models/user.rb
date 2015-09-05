class User < ActiveRecord::Base
  belongs_to :group
  has_many :groups
  has_many :group_memberships, dependent: :destroy
  has_attached_file :personal_photo, :styles => { :medium => "600x600#", :thumb => "120x120#" },
                    :default_url => ":style/default_image.png"
  validates_with AttachmentContentTypeValidator, attributes: :personal_photo, :content_type => /\Aimage\/.*\Z/
  # validates_attachment_content_type :personal_photo, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :personal_photo, less_than: 2.megabytes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :validatable, password_length: 8..128
  validates :first_name, :last_name, :presence => true
end
