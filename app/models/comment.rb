class Comment < ApplicationRecord
  before_update :check_edit_limit, if: :will_save_change_to_content?
  belongs_to :user
  belongs_to :post
  after_create :award_experience

  validates :content, presence: true

  private

  def check_edit_limit
    if self.edit_count >= 1
      errors.add(:base, 'このコメントは既に編集済みです')
      throw :abort
    end
  end

  def award_experience
    # コメント作成者に基本の経験値を付与
    return if user.guest?  # ゲストユーザーの場合は何もしない
  
    if post.user_id == user.id
      # 自身のスレッドへのコメントの場合は1ポイントの経験値を付与
      user.add_experience(1)
    else
      # 他のスレッドへのコメントの場合は5ポイントの経験値を付与
      user.add_experience(5)
  
      # コメントされたスレッドの作成者に10ポイントの経験値を付与
      User.find(post.user_id).add_experience(10) if post.user_id != user.id
    end
  end
  
end
