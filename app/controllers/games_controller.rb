class GamesController < ApplicationController
  def index
    @user = current_user
    @skills = @user.skills.order(created_at: :desc)
  end

  def escape
    @user = current_user
    @character = find_character # ここでキャラクターを取得するメソッドを追加

    if can_escape?
      result = "#{current_user.nickname}は逃げ切った!!"
      # JSON形式でレスポンスを返す場合
      # ここにsetTimeout(() => {
    #     // 次の処理
    #     // 例えば、結果画面に遷移するなど
    #     window.location.href = '/results'; // 遷移先のURL
    # }, 1500); // 1500ミリ秒（1.5秒）待機
    # のようなjsのコードをjsのコードに付け加える
      render json: { message: result }
      
    else
      result = "#{@character.name}が後を追いかけてきた!!"
      # 追跡された場合もJSON形式でレスポンスを返す
      render json: { message: result }
      character_action
    end
  end

  private

  def can_escape?
    speed_difference = @character.speed - @user.speed
    escape_probability = speed_difference > 0 ? 100 - speed_difference : 100

    rand < escape_probability * 0.01
  end

  def find_character
    # ここで適切なキャラクターを取得するロジックを実装
    Character.find(params[:character_id]) # 例: character_idをパラメータから取得
  end
end
