# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Level.create(level_number: 0, exp_required: 10, hp_increase: 3, offense_increase: 0, defense_increase: 0,
speed_increase: 0, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 1, exp_required: 50, hp_increase: 3, offense_increase: 1, defense_increase: 1,
speed_increase: 1, luck_increase: 0, status_point_increase: 0, reward_type: 'skill' , reward_value: 'speak')
Level.create(level_number: 2, exp_required: 75, hp_increase: 3, offense_increase: 1, defense_increase: 1,
speed_increase: 1, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 3, exp_required: 100, hp_increase: 3, offense_increase: 0, defense_increase: 1,
speed_increase: 1, luck_increase: 1, status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 4, exp_required: 125, hp_increase: 3, offense_increase: 1, defense_increase: 1,
speed_increase: 1, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 5, exp_required: 150, hp_increase: 3, offense_increase: 1, defense_increase: 1,
speed_increase: 0, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 6, exp_required: 175, hp_increase: 3, offense_increase: 1, defense_increase: 1,
speed_increase: 1, luck_increase: 1, status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 7, exp_required: 200, hp_increase: 3, offense_increase: 1, defense_increase: 1,
speed_increase: 1, luck_increase: 1, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 8, exp_required: 225, hp_increase: 3, offense_increase: 1, defense_increase: 1,
speed_increase: 1, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 9, exp_required: 250, hp_increase: 3, offense_increase: 1, defense_increase: 0,
speed_increase: 1, luck_increase: 1, status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 10, exp_required: 275, hp_increase: 6, offense_increase: 2, defense_increase: 2,
 speed_increase: 2, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 11, exp_required: 300, hp_increase: 6, offense_increase: 1, defense_increase: 2,
 speed_increase: 1, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 12, exp_required: 330, hp_increase: 6, offense_increase: 2, defense_increase: 1,
 speed_increase: 2, luck_increase: 2, status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 13, exp_required: 360, hp_increase: 6, offense_increase: 2, defense_increase: 2,
 speed_increase: 1, luck_increase: 0, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 14, exp_required: 390, hp_increase: 6, offense_increase: 2, defense_increase: 1,
 speed_increase: 2, luck_increase: 1, status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 15, exp_required: 420, hp_increase: 6, offense_increase: 2, defense_increase: 2,
 speed_increase: 2, luck_increase: 2, status_point_increase: 4, reward_type: nil, reward_value: nil)
Level.create(level_number: 16, exp_required: 450, hp_increase: 6, offense_increase: 2, defense_increase: 2,
 speed_increase: 1, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 17, exp_required: 480, hp_increase: 6, offense_increase: 2, defense_increase: 2,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 18, exp_required: 520, hp_increase: 6, offense_increase: 1, defense_increase: 2,
 speed_increase: 2, luck_increase: 2,status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 19, exp_required: 560, hp_increase: 6, offense_increase: 2, defense_increase: 1,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 20, exp_required: 600, hp_increase: 9, offense_increase: 2, defense_increase: 2,
 speed_increase: 3, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 21, exp_required: 650, hp_increase: 9, offense_increase: 1, defense_increase: 2,
 speed_increase: 1, luck_increase: 4,status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 22, exp_required: 700, hp_increase: 9, offense_increase: 2, defense_increase: 1,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 23, exp_required: 750, hp_increase: 9, offense_increase: 1, defense_increase: 2,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 24, exp_required: 800, hp_increase: 9, offense_increase: 2, defense_increase: 1,
 speed_increase: 2, luck_increase: 3,status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 25, exp_required: 850, hp_increase: 9, offense_increase: 2, defense_increase: 2,
 speed_increase: 3, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 26, exp_required: 900, hp_increase: 9, offense_increase: 2, defense_increase: 2,
 speed_increase: 1, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 27, exp_required: 950, hp_increase: 9, offense_increase: 2, defense_increase: 2,
 speed_increase: 2, luck_increase: 3,status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 28, exp_required: 1000, hp_increase: 9, offense_increase: 2, defense_increase: 2,
 speed_increase: 1, luck_increase: 1,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 29, exp_required: 1050, hp_increase: 9, offense_increase: 2, defense_increase: 2,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 30, exp_required: 1200, hp_increase: 12, offense_increase: 3, defense_increase: 3,
 speed_increase: 3, luck_increase: 3,status_point_increase: 5, reward_type: nil, reward_value: nil)
Level.create(level_number: 31, exp_required: 1350, hp_increase: 12, offense_increase: 1, defense_increase: 3,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 32, exp_required: 1500, hp_increase: 12, offense_increase: 3, defense_increase: 1,
 speed_increase: 3, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 33, exp_required: 1650, hp_increase: 12, offense_increase: 2, defense_increase: 3,
 speed_increase: 3, luck_increase: 3,status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 34, exp_required: 1800, hp_increase: 12, offense_increase: 3, defense_increase: 2,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 35, exp_required: 1950, hp_increase: 12, offense_increase: 3, defense_increase: 1,
 speed_increase: 4, luck_increase: 1,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 36, exp_required: 2100, hp_increase: 12, offense_increase: 3, defense_increase: 2,
 speed_increase: 2, luck_increase: 3,status_point_increase: 3, reward_type: nil , reward_value: nil)
Level.create(level_number: 37, exp_required: 2250, hp_increase: 12, offense_increase: 2, defense_increase: 3,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0, reward_type: nil , reward_value: nil)
Level.create(level_number: 38, exp_required: 2500, hp_increase: 12, offense_increase: 3, defense_increase: 2,
 speed_increase: 3, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 39, exp_required: 2750, hp_increase: 12, offense_increase: 2, defense_increase: 3,
 speed_increase: 2, luck_increase: 3,status_point_increase: 3, reward_type: nil, reward_value: nil)
Level.create(level_number: 40, exp_required: 3000, hp_increase: 15, offense_increase: 4, defense_increase: 4,
 speed_increase: 4, luck_increase: 0,status_point_increase: 0, reward_type: nil, reward_value: nil)
Level.create(level_number: 41, exp_required: 3350, hp_increase: 15,  offense_increase: 2, defense_increase: 4,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0,reward_type: nil, reward_value: nil)
Level.create(level_number: 42, exp_required: 3700, hp_increase: 15,  offense_increase: 4, defense_increase: 2,
 speed_increase: 2, luck_increase: 4,status_point_increase: 3,reward_type: nil, reward_value: nil)
Level.create(level_number: 43, exp_required: 4050, hp_increase: 15,  offense_increase: 2, defense_increase: 4,
 speed_increase: 2, luck_increase: 0,status_point_increase: 0,reward_type: nil, reward_value: nil)
Level.create(level_number: 44, exp_required: 4400, hp_increase: 15,  offense_increase: 2, defense_increase: 4,
 speed_increase: 3, luck_increase: 0,status_point_increase: 0,reward_type: nil, reward_value: nil)
Level.create(level_number: 45, exp_required: 4750, hp_increase: 15,  offense_increase: 4, defense_increase: 3,
 speed_increase: 4, luck_increase: 3,status_point_increase: 4,reward_type: nil, reward_value: nil)
Level.create(level_number: 46, exp_required: 5100, hp_increase: 15,  offense_increase: 3, defense_increase: 4,
 speed_increase: 3, luck_increase: 0,status_point_increase: 0,reward_type: nil, reward_value: nil)
Level.create(level_number: 47, exp_required: 5450, hp_increase: 15,  offense_increase: 4, defense_increase: 3,
 speed_increase: 4, luck_increase: 0,status_point_increase: 0,reward_type: nil, reward_value: nil)
Level.create(level_number: 48, exp_required: 5700, hp_increase: 15,  offense_increase: 4, defense_increase: 2,
 speed_increase: 2, luck_increase: 3,status_point_increase: 3,reward_type: nil, reward_value: nil)
Level.create(level_number: 49, exp_required: 6050, hp_increase: 15,  offense_increase: 2, defense_increase: 4,
 speed_increase: 4, luck_increase: 1,status_point_increase: 0,reward_type: nil, reward_value: nil)
Level.create(level_number: 50, exp_required: 7000, hp_increase: 0,  offense_increase: 0, defense_increase: 0,
 speed_increase: 0, luck_increase: 0,status_point_increase: 0,reward_type: "item", reward_value: "atom-candy")




Character.create(number: 1, name: "エイチツインズ", image: "big-h-twins-gals.png", max_hp:30, current_hp:30, offense_power: 3, defense_power: 5, speed: 3,
likeability: 0, luck: 5, experience_points: 100, traits: "会話系のスキルが効きやすい",favorite_item: "携帯", healing_power: 10, alignment: "悪",
backstory: "二人ならうちらマヂ最強じゃんの一声で合体した")

Character.create(number: 2, name: "てぶくろディスパッチ", image: "tebukurodispatch3.png", max_hp:30, current_hp:30, offense_power: 5, defense_power: 1, speed: 70,
likeability: 0, experience_points: 500, traits: "瀕死になると手袋を脱いで逃げる",favorite_item: "手袋", healing_power: 15, alignment: "悪",
backstory: "Inverse Regimeのメンバー、偵察部隊隊長")




#  def your_luck(luck)
#   # luckの値に応じて、luck_number_rangeの割合を調整
#   luck_number = rand(1..100)

#   low_range_end = 33 - [luck / 3, 33].min  # 最小値は0以上
#   medium_range_end = 66 - [luck / 3, 33].min  # 中央の範囲を広げる
#   if luck_number <= low_range_end
#     luck_result = 'low_number'
#   elsif luck_number <= medium_range_end
#     luck_result = 'medium_number'
#   else
#     luck_result = 'high_number'
#   end

#   luck_result
# end






