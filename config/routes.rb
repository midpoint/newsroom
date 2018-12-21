Rails.application.routes.draw do

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :feeds, only: [:new, :create]
  root 'welcome#index'
end
