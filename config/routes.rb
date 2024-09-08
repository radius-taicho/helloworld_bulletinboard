Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  resources :users, only: [:show]

  resources :posts do
    resources :comments
    collection do
      get 'search'
    end
  end

  resources :direct_message_requests, only: [:create] do
    member do
      get 'approve' # ここでapproveアクションのルーティングを追加
    end
  end

  root to: "posts#index"
end
