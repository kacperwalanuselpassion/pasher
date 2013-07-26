Gapi::Application.routes.draw do
  get "welcome/index"
  resources :orders, defaults: { format: 'json' }
  root to: 'welcome#index'
end
