Gapi::Application.routes.draw do
  get "welcome/index"

  match "/sign_in" => "welcome#sign_in", via: [:get]
  match "/sign_out" => "sessions#destroy", :as => :sign_out, via: [:get, :post]
  match "/auth/google_login/callback" => "sessions#create", via: [:get, :post]

  get 'order_finalize', to: 'orders#finalize'
  resources :orders, defaults: { format: 'json' }
  resources :dishes, defaults: { format: 'json' } do
    member do
      put :join
    end
  end
  resources :chat_messages, defaults: { format: 'json' }
  resources :bitcoin_wallets, only: %w(show index)

  root to: 'welcome#index'
end
