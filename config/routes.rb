Gapi::Application.routes.draw do
  get "welcome/index"

  match "/sign_in" => "welcome#sign_in", via: [:get]
  match "/sign_out" => "sessions#destroy", :as => :sign_out, via: [:get, :post]
  match "/auth/google_login/callback" => 'sessions#create', via: [:get, :post]
  get "/auth/pasher_login" => "users#login"
  post "/auth/pasher_login/callback" => 'sessions#create'
  post "/pasher/sign_up" => 'sessions#create'

  get 'order_finalize', to: 'orders#finalize'
  resources :orders, defaults: { format: 'json' }
  resources :dishes, defaults: { format: 'json' } do
    member do
      put :join
    end
  end
  resources :chat_messages, defaults: { format: 'json' }
  resources :bitcoin_wallets, only: %w(show index)
  resources :users, only: %w(new)

  root to: 'welcome#index'
end
