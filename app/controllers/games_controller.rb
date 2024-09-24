class GamesController < ApplicationController
  def index
    @user = current_user # ログインユーザーや対象ユーザーを取得
    @skills = @user.skills.order(created_at: :desc)               # ユーザーの持つスキルを取得
  end
end
