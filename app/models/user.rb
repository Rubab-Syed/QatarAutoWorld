class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  validates :fullname, presence: true, length: {maximum: 50}
  validates :email, presence: true
  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :reviews

  enum status: [ :employed, :student, :self_employed, :looking_for_work, :other]

  has_attached_file :avatar, dependent: :destroy, :default_url => ''
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  
  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    
    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
        user.fullname = auth.info.name
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.image = auth.info.image
        user.password = Devise.friendly_token[0,20]
        user.confirmed_at = DateTime.now
      end
    end
  end

  def skip_confirmation!
    self.confirmed_at = DateTime.now
  end

  def email_changed?
    false
  end
end
