class ThreadsController < ApplicationController

  def index
    
  end

  def destroy
    redirect_to root_path, notice: "ログアウトしました"
  end
end
