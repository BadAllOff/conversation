class User < ActiveRecord::Base
  has_many :authentications, dependent: :destroy
  belongs_to :group
  has_many :groups, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  validates_with AttachmentContentTypeValidator, attributes: :personal_photo, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :personal_photo, less_than: 2.megabytes
  has_attached_file(:personal_photo,
                    styles: { :medium => "600x600#", :thumb => "120x120#" },
                    default_url: ":style/default_image.png",
                    storage: :s3,
                    s3_credentials: "#{Rails.root}/config/s3.yml",
                    s3_protocol: 'https'
  )
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

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

end
