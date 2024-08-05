Rails.application.routes.draw do
  get 'threads/index'
  root to: "threads#index"
end
