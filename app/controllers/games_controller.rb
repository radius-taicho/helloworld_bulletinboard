class GamesController < ApplicationController
  def index
    @user = current_user
    @skills = @user.skills.order(created_at: :desc)
  end

  def escape
    @user = current_user
    @character = Character.find_by(number: 1) # numberが1のキャラクターを取得
  
    if can_escape?
      result = "#{current_user.nickname}は逃げ切った!!"
      render json: { message: result }
      
    else
      result = "#{@character.name}が後を追いかけてきた!!"
      # 追跡された場合もJSON形式でレスポンスを返す
      render json: { message: result }
    end
  end
  

  private

  def can_escape?
    speed_difference = @character.speed - @user.speed
  
    # スピード差に応じた逃げられる確率を設定
    escape_probability = case speed_difference
                         when 1 then 90
                         when 2 then 80
                         when 3 then 70
                         when 4 then 60
                         when 5 then 50
                         when 6 then 40
                         when 7 then 30
                         when 8..Float::INFINITY then 20 # スピード差が8以上の場合
                         else 100 # ユーザーが速い場合は100%
                         end
  
    # 確率をパーセンテージで評価
    rand < escape_probability * 0.01
  end

end
