Gapi::Application.routes.draw do
  get "welcome/index"

  match "/auth/google_login/callback" => "sessions#create", via: [:get, :post]
  match "/signout" => "sessions#destroy", :as => :signout, via: [:get]

  resources :orders, defaults: { format: 'json' }

  root to: 'welcome#index'
end
