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
  has_many :skills

   # 初期レベル0を設定するメソッド
   after_create :set_initial_level

  def add_experience(points)
    self.experience_points += points
    level_up if experience_points >= current_level.exp_required
    save
  end
  
  def level_up
    transaction do
      while experience_points >= current_level&.exp_required
        self.experience_points -= current_level.exp_required
        self.level_id = next_level.id
      end
      if save
        self.max_hp += current_level.hp_increase
        self.hp = [self.hp, max_hp].min # 既存のHPが最大HPを超えないようにするp

        unlock_rewards_for_level(current_level)
        save_level_up_notification(current_level)
      else
        # エラーハンドリング
        Rails.logger.error("Failed to save user after leveling up.")
      end
    end
  end

  def save_level_up_notification(level)
    message = "Lv.#{level.level_number}になりました！"

    # 通知をデータベースに保存
    notifications.create(
      message: message,
      notification_type: "level_up",
      next_experience_point: level.exp_required,
      required_comment_count: level.exp_required / 5,
      skill_get_message: level.reward_value.present? && level.reward_type == "skill" ? "新しいスキル「#{level.reward_value}」を獲得しました！" : "",
      item_get_message: level.reward_value.present? && level.reward_type == "item" ?  "新しいアイテム「#{level.reward_value}」を獲得しました！" : ""
    )

  end

  def unlock_rewards_for_level(level)
    case level.reward_type
    when 'skill'
      unlock_skill(level.reward_value)
      LevelUpNotificationChannel.broadcast_to(self, {
        level_up_message: "レベル#{level.level_number}に到達しました！",
        skill_get_message: "新しいスキル「#{level.reward_value}」を獲得しました！",
        next_experience_point: "次のレベルに必要な経験値: #{level.exp_required}",
        required_comment_count: "必要最低コメント数: #{level.exp_required / 5}"
      })
    when 'item'
      unlock_item(level.reward_value)
      LevelUpNotificationChannel.broadcast_to(self, {
        level_up_message: "レベル#{level.level_number}に到達しました！",
        item_get_message: "新しいアイテム「#{level.reward_value}」を獲得しました！",
        next_experience_point: "次のレベルに必要な経験値: #{level.exp_required}",
        required_comment_count: "必要最低コメント数: #{level.exp_required / 5}"
      })
    else
      LevelUpNotificationChannel.broadcast_to(self, {
        level_up_message: "レベル#{level.level_number}に到達しました！",
        next_experience_point: "次のレベルに必要な経験値: #{level.exp_required}",
        required_comment_count: "必要最低コメント数: #{level.exp_required / 5}"
      })
    end
  end

  def unlock_skill(skill_name)
    # スキルをユーザーに付与する処理
    skills.create(name: skill_name)
  end

  def unlock_item(item_name)
    # アイテムをユーザーに付与する処理
    items.create(name: item_name)
  end

  def current_level
    Level.find(level_id) # 現在のレベルを取得
  end
  
  def next_level
    Level.where("level_number > ?", current_level.level_number).order(:level_number).first || current_level
  end

  def recover_hp(amount)
    self.hp += amount
    self.hp = [self.hp, max_hp].min # 最大HPを超えないようにする
    save
  end

  def decrease_hp(amount)
    self.hp -= amount
    self.hp = [self.hp, 0].max # HPが0未満にならないようにする
    save
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

  private

  def set_initial_level
    self.level = Level.find_by(level_number: 0) # レベル0を初期設定
    self.hp = 3
    self.max_hp = 3
    save
  end
end
