Rails.application.routes.draw do
  devise_for :users
  root "sleep_ms#index"
  resources :sleep_ms
end
