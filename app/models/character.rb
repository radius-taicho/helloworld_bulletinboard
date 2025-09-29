class Character < ApplicationRecord
  has_many :user_characters
  has_many :users, through: :user_characters
  has_many :character_abilities, dependent: :destroy
  has_many :status_effects, dependent: :destroy
  has_many :games
end
