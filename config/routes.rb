Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  resources :users, only: [:show, :edit, :update]

  get '/latest_posts', to: 'posts#latest'

  resources :posts do
    resources :comments
    collection do
      get 'search'
      get 'latest'
    end
  end

  

  resources :direct_message_requests, only: [:create] do
    member do
      patch :approve
      patch :reject
    end
  end
  
  # 既存のnotificationsに追加
  resources :notifications, only: [] do
    member do
      patch 'mark_as_read'
    end
    collection do
      patch 'approval', to: 'notifications#create_approval_notification'
      patch 'rejection', to: 'notifications#create_rejection_notification'
    end
  end

  resources :rooms do
    resources :messages, only: [:create] # ここで messages リソースをネスト
  end


  root to: "posts#index"
end
