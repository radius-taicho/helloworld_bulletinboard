class Game < ApplicationRecord
  belongs_to :user
  belongs_to :character

  # 攻撃力の一時的な増加を管理するための変数
  attr_accessor :original_offense_power

  # コマンドによる処理の分岐
  def process_command(command)
    log = []
    escape_success = false # 逃走成功フラグを初期化

    # コマンドを分割して処理する
    command_parts = command.split(' ')
    action = command_parts[0] # コマンドの最初の部分をアクションとして取得
    skill_name = command_parts[1] # 2番目の部分をスキル名として取得

    case action
    when 'attack'
      log = process_attack
      reset_user_attack_power # 攻撃力を元に戻す
    when 'item'
      log = process_item
    when 'escape'
      log, escape_success = process_escape
    else
      # スキル名がある場合の処理
      if ['hello', 'speak'].include?(action)
        log = process_skill(action)
      elsif skill_name && ['hello', 'speak'].include?(skill_name)
        log = process_skill(skill_name)
      end
    end

    if battle_over?
      if user.hp <= 0
        log << "#{user.nickname}は力尽きた！"
      elsif character.current_hp <= 0
        log << "#{character.name}が消滅した！"
        reset_user_attack_power
        user_gain_exp(character.experience_points)
        character.likeability = 0
        character.save
        log << "#{user.nickname}は#{character.experience_points}の経験値を獲得した！"
      end
    end

    puts "生成されたログ: #{log.inspect}" # デバッグ用ログ出力

    {
      log: log,
      battle_over: battle_over?,
      next_turn: !battle_over? && !escape_success,
      user_max_hp: user.max_hp,
      user_hp: user.hp
    }
  end

  # ユーザーの経験値加算
  def user_gain_exp(exp)
    user.add_experience(exp)
    user.save
  end

  # ユーザーの攻撃処理
  def process_attack
    log = []
    if user.speed >= character.speed
      log = user_attack(log)
      log = character_attack(log) unless battle_over?
    else
      log = character_attack(log) unless battle_over?
      log = user_attack(log) unless battle_over?
    end
    log
  end

  # スキル使用処理
  def process_skill(command)
    log = []
    case command
    when 'hello'
      log = user_use_hello(log)
    when "speak"
      log = user_use_speak(log)
    else
      # 他のスキルがあれば追加
    end

    # ここでログが空でないか確認する
    if log.empty?
      log << "ログがありません"
    end

    log
  end

  # Helloスキルの処理
  def user_use_hello(log)
    current_time = Time.now

    if rand < 0.7 && current_time.hour >= 5 && current_time.hour < 12
      handle_greeting(log, "おはようございます！", "おはよう！", "お、おはようございます..")
    elsif rand < 0.7 && current_time.hour >= 12 && current_time.hour < 17
      handle_greeting(log, "こんにちは！", "こんにちは！", "こ、こんにちは..")
    elsif rand < 0.7 && (current_time.hour >= 17 || current_time.hour < 5)
      handle_greeting(log, "こんばんは！", "こんばんは！", "こ、こんばんは..")
    else
      log << "#{character.name}は無視した！"
      log = character_attack(log) unless battle_over? # 無視された場合の処理
      log << "#{user.nickname}はイラついた！"
      user_power_up # 攻撃力を増加
    end

    # ここで必ず何らかのログがあることを確認する
    if log.empty?
      log << "#{user.nickname}は何もできなかった。"
    end

    log
  end

  # 挨拶処理をまとめたメソッド
  def handle_greeting(log, user_greeting, friendly_response, shy_response)
    character.likeability += 1
    character.save
    log << "#{user.nickname}「#{user_greeting}」"

    if character.likeability >= 30
      log << "#{character.name}「#{friendly_response}」"
    else
      log << "#{character.name}「#{shy_response}」"
    end
  end

  def user_use_speak(log)
    # スピークスキルの処理をここに追加
  end

  # 攻撃力を増加させるメソッド
  def user_power_up
    @original_offense_power = user.offense_power # 元の攻撃力を保存
    user.offense_power *= 1.25 # 攻撃力を増加
    user.save
  end

  # 攻撃力を元に戻すメソッド
  def reset_user_attack_power
    if @original_offense_power
      user.offense_power = @original_offense_power # 元の攻撃力に戻す
      user.save
      @original_offense_power = nil # 一時的な保存を解除
    end
  end

  # アイテム使用処理
  def process_item
    log = []
    log = user_use_item(log)
    log = character_attack(log) unless battle_over?
    log
  end

  # アイテム使用時のHP回復処理
  def user_use_item(log)
    recovery_amount = 10 # 仮の回復量
    user.hp += recovery_amount
    user.hp = user.max_hp if user.hp > user.max_hp
    user.save

    log << "#{user.nickname}はアイテムを使用してHPを#{recovery_amount}回復した！"
    log
  end

  # 逃走処理
  def process_escape
    log = []
    escape_success = false
    if user_can_escape?
      log << "#{user.nickname}は逃げ切った！"
      escape_success = true
      user_gain_exp(5)
    else
      log << "#{character.name}が追いかけてきた！"
      log = character_attack(log)
    end
    [log, escape_success]
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
  def user_attack(log)
    damage, critical = calculate_damage(user, character)
    if critical
      log << "#{user.nickname}のクリティカルヒット！"
    end
    character.current_hp -= damage
    character.save

    log << "#{user.nickname}が#{damage}のダメージを与えた！"
    log
  end

  # キャラクターの攻撃処理
  def character_attack(log)
    damage, critical = calculate_damage(character, user)
    if critical
      log << "#{character.name}のクリティカルヒット！"
    end
    user.hp -= damage
    user.hp = [user.hp, 0].max # HPが0未満にならないように
    user.save

    log << "#{character.name}が#{damage}のダメージを与えた！"
    log
  end

  # ダメージ計算処理
  def calculate_damage(attacker, defender)
    base_damage = [attacker.offense_power - defender.defense_power, 0].max
    damage_with_randomness = (base_damage * rand(0.8..1.2)).round

    critical = false
    if rand < attacker.luck * 0.01
      damage_with_randomness *= 2
      critical = true
    end

    [damage_with_randomness, critical]
  end

  # 逃走成功判定
  def user_can_escape?
    speed_difference = character.speed - user.speed
    escape_probability = case speed_difference
                         when 1 then 90
                         when 2 then 80
                         when 3 then 70
                         when 4 then 60
                         when 5 then 50
                         when 6 then 40
                         when 7 then 30
                         when 8..Float::INFINITY then 20
                         else 0
                         end

    rand < (escape_probability / 100.0)
  end
end
