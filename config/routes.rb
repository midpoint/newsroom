require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :feeds, only: [:show, :new, :create]

  resources :stories, only: [] do
    member do
      post :read
    end
  end

  root 'welcome#index'
end
