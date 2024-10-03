class Game < ApplicationRecord
  belongs_to :user
  belongs_to :character

  def process_command(command)
    log = []

    # コマンドによる処理の分岐
    case command
    when 'attack'
      log.concat(process_attack)
    when 'skill'
      log.concat(process_skill)
    when 'item'
      log.concat(process_item)
    when 'escape'
      log.concat(process_escape)
    end

    # バトル終了時のログを追加
    if battle_over?
      log << "#{user.nickname}は力尽きた！" if user.hp <= 0
      log << "#{character.name}が消滅した！" if character.current_hp <= 0
    end

    {
      log: log,
      battle_over: battle_over?,
      next_turn: !battle_over?,
      user_max_hp: user.max_hp,
      user_hp: user.hp, # HPを正しく返す
      current_user: user
    }
  end

  # ユーザーの攻撃処理
  def process_attack
    log = []
    if user.speed >= character.speed
      log << user_attack
      log << character_attack unless battle_over?
    else
      log << character_attack unless battle_over?
      log << user_attack unless battle_over?
    end
    log # ログ配列を返す
  end

  # スキル使用処理
  def process_skill
    log = []
    log << user_use_skill
    log << character_attack unless battle_over?
    log # ログ配列を返す
  end

  # アイテム使用処理
  def process_item
    log = []
    log << user_use_item
    log << character_attack unless battle_over?
    log # ログ配列を返す
  end

  # 逃げる処理
  def process_escape
    log = []
    if user_can_escape?
      log << "#{user.nickname}は逃げ切った！"
    else
      log << "#{character.name}が追いかけてきた！"
      log << character_attack
    end
    log # ログ配列を返す
  end

  # 戦闘終了判定
  def battle_over?
    if user.hp <= 0
      user.hp = 0 # HPが0未満にならないように
      user.save
      return true
    elsif character.current_hp <= 0
      return true
    end
    false
  end

  # ユーザーの攻撃処理
  def user_attack
    damage = calculate_damage(user, character)
    character.current_hp -= damage
    character.save
    
    "#{user.nickname}が#{damage}のダメージを与えた！"
  end

  # キャラクターの攻撃処理
  def character_attack
    damage = calculate_damage(character, user)
    user.hp -= damage
    user.hp = [user.hp, 0].max # HPが0未満にならないように
    user.save
    "#{character.name}が#{damage}のダメージを与えた！"
  end

  # ダメージ計算
  def calculate_damage(attacker, defender)
    [attacker.offense_power - defender.defense_power, 0].max
  end

  # スキル使用処理
  def user_use_skill
    damage = calculate_skill_damage(user, character)
    character.current_hp -= damage
    character.save
    "ユーザーはスキルを使用して#{damage}のダメージを与えた！"
  end

  # アイテム使用処理
  def user_use_item
    # 例: HP回復アイテム
    recovery_amount = 20 # 回復量を仮定
    user.hp += recovery_amount

    # HPがmax_hpを超えないように制御
    user.hp = user.max_hp if user.hp > user.max_hp
    
    user.save
    "#{user.nickname}はアイテムを使用してHPを#{recovery_amount}回復した！"
  end

  # スキルのダメージ計算
  def calculate_skill_damage(user, character)
    user.skill_power - character.defense_power
  end

  # 逃走可能か判定する処理
  def user_can_escape?
    speed_difference = character.speed - user.speed

    # スピード差に応じた逃げられる確率を設定
    escape_probability = case speed_difference
                         when 1 then 90
                         when 2 then 80
                         when 3 then 70
                         when 4 then 60
                         when 5 then 50
                         when 6 then 40
                         when 7 then 30
                         when 8..Float::INFINITY then 20
                         else 100
                         end

    # 確率をパーセンテージで評価
    rand < escape_probability * 0.01
  end
end
