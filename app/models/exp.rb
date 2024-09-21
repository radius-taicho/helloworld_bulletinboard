class Exp < ApplicationRecord
  belongs_to :user
  belongs_to :related_entity, polymorphic: true  # ポリモーフィック関連

  # 経験値の発生源をenumで定義
  enum source: { 
    comment: 'comment', 
    thread_reaction: 'thread_reaction', 
    user_defeat: 'user_defeat', 
    character_defeat: 'character_defeat',
    recruit_character: 'recruit_character', 
    user_running: 'user_running', 
    character_running: 'character_running', 
    item_getting: 'item_getting'
  }
end
