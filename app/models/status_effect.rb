class StatusEffect < ApplicationRecord
  belongs_to :character, optional: true
  belongs_to :user, optional: true
end