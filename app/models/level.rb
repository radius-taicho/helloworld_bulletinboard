class Level < ApplicationRecord
  has_many :users
  validates :level_number, presence: true, uniqueness: true
  validates :exp_required, :hp_increase, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # 例: レベルの報酬を整形するメソッド
  def formatted_reward
    "#{reward_type}: #{reward_value}"
  end
end
