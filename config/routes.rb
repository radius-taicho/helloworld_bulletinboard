Rails.application.routes.draw do
  devise_for :users
  get 'threads/index'
  root to: "threads#index"
end
