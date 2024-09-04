class Comment < ApplicationRecord
  before_update :check_edit_limit, if: :will_save_change_to_content?
  belongs_to :user
  belongs_to :post

  validates :content, presence: true

  private

  def check_edit_limit
    if self.edit_count >= 1
      errors.add(:base, 'このコメントは既に編集済みです')
      throw :abort
    end
  end
end
