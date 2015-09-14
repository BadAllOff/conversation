class User < ActiveRecord::Base
  has_many :authentications
  belongs_to :group
  has_many :groups, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_attached_file :personal_photo, :styles => { :medium => "600x600#", :thumb => "120x120#" },
                    :default_url => ":style/default_image.png"
  validates_with AttachmentContentTypeValidator, attributes: :personal_photo, :content_type => /\Aimage\/.*\Z/
  # validates_attachment_content_type :personal_photo, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :personal_photo, less_than: 2.megabytes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :confirmable, :validatable, password_length: 8..128
  validates :first_name, :last_name, :presence => true

  def apply_omniauth(omni)
    authentications.build(provider: omni['provider'],
                          uid: omni['uid'],
                          token: omni['credentials']['token'],
                          token_secret: omni['credentials']['secret'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
