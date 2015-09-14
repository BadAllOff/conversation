class User < ActiveRecord::Base
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
  devise :database_authenticatable, :registerable, :omniauthable, :recoverable, :rememberable, :trackable, :confirmable, :validatable, password_length: 8..128
  validates :first_name, :last_name, :presence => true


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      # user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name   # assuming the user model has a name e
    end
  end

  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection:true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
