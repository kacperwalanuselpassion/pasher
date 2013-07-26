Gapi::Application.routes.draw do
  resources :orders, defaults: { format: 'json' }
  root to: 'orders#index'
end
