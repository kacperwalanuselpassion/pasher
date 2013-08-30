Gapi::Application.routes.draw do
  get "welcome/index"

  match "/sign_in" => "welcome#sign_in", via: [:get]
  match "/sign_out" => "sessions#destroy", :as => :sign_out, via: [:get, :post]
  match "/auth/google_login/callback" => "sessions#create", via: [:get, :post]

  resources :orders, defaults: { format: 'json' }

  root to: 'welcome#index'
end
