class GamesController < ApplicationController
  before_action :set_game, only: [:show, :execute_command, :result]

  # ゲーム開始処理
  def start_game
    @user = current_user
    @character = Character.find_by(number: 1) # キャラクターを取得

    # ユーザーのHPを初期化

    # 新しいゲームを作成
    @game = Game.create(user: @user, character: @character)

    @character.update(
      current_hp: @character.max_hp,           # HPを最大値にリセット
      offense_power: @character.offense_power, # 基本攻撃力にリセット
      defense_power: @character.defense_power, # 基本防御力にリセット
      speed: @character.speed,                 # 基本スピードにリセット
      luck: @character.luck                    # 基本運にリセット
    )
    # コマンド選択画面へリダイレクト
    redirect_to game_path(@game) # ゲーム画面へ遷移
  end

  # ゲーム画面の表示
  def show
    @user = @game.user
    @character = @game.character
    @skills = @user.skills.order(created_at: :desc)
  end

  # コマンドを処理
  def execute_command
    command = params[:command] # フォームからのコマンドを取得
  
    # 有効なコマンドのリストを定義
    valid_commands = ['attack', 'skill', 'item', 'escape', 'hello', 'speak'] # helloとspeakを追加
  
    # コマンドのバリデーション
    unless valid_commands.include?(command)
      flash[:alert] = "無効なコマンドです。"
      redirect_to root_path and return
    end
  
    result = @game.process_command(command) # Gameモデルのメソッドで処理
  
    if result[:battle_over]
      render json: { 
        log: result[:log], 
        battle_over: true, 
        user_hp: result[:user_hp], 
        user_max_hp: result[:user_max_hp]
      }
    else
      # resultからユーザーのHPを取得
      render json: { 
        log: result[:log], 
        battle_over: false, 
        next_turn: result[:next_turn], # 次のターンの情報を追加して返す
        user_hp: result[:user_hp], 
        user_max_hp: result[:user_max_hp]
      }
    end
  end

  def result
    @character = @game.character
    @user = @game.user
  end

  private

  def set_game
    @game = Game.find(params[:id]) # ゲームを取得
  end
end
