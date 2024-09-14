class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  belongs_to :level
  has_many :sns_credentials
  has_many :posts
  has_many :comments
  has_many :room_users
  has_many :rooms, through: :room_users
  has_many :messages, foreign_key: :sender_id
  has_many :direct_message_requests, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def add_experience(points)
    self.experience_points += points
    level_up if experience_points >= current_level.exp_required
    save
  end
  
  def level_up
    transaction do
      while experience_points >= current_level.exp_required
        self.experience_points -= current_level.exp_required
        self.level_id = next_level.id
      end
      save
    end
  end
  
  
  def current_level
    Level.find(level_id) # 現在のレベルを取得
  end
  
  def next_level
    Level.where("level_number > ?", current_level.level_number).order(:level_number).first || current_level
  end

  def guest?
    email == 'guest@example.com'
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.nickname = 'ゲスト'
      user.password = SecureRandom.urlsafe_base64 # ゲスト用のパスワード
      user.password_confirmation = user.password
    end
  end

  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    user = User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
      email: auth.info.email
    )
    if user.persisted?
      sns.user = user
      sns.save
    end
    user
  end
end
