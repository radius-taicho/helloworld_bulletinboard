class GamesController < ApplicationController
  before_action :set_game, only: [:show, :execute_command]

  # ゲーム開始処理
  def start_game
    @user = current_user
    @character = Character.find_by(number: 1) # キャラクターを取得

    # 新しいゲームを作成
    @game = Game.create(user: @user, character: @character)

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
    valid_commands = ['attack', 'skill', 'item', 'escape']
    
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
      current_user = result[:current_user] # 現在のユーザーオブジェクトを取得
  
      render json: { 
        log: result[:log], 
        battle_over: false, 
        next_turn: result[:next_turn], # 次のターンの情報を追加して返す
        user_hp: current_user.hp, 
        user_max_hp: current_user.max_hp     # ユーザーの現在HP
      }
    end
  end

  private

  # ゲームデータを設定
  def set_game
    @game = Game.find(params[:id])
  end
end
