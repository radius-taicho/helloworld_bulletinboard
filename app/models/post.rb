class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy

  
  validates :title, presence: true
  validates :content, presence: true, unless: :was_attached?

  def was_attached?
    self.image.attached?
  end

  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(self.image, only_path: true) if image.attached?
  end
end
