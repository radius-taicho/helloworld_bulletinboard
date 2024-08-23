Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  # Postsリソースのルーティング
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  # トップページの設定
  root to: "posts#index"
end
