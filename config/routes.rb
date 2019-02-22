# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/search' => 'search#index'

  resources :feeds, only: [:new, :create]
  resources :items, only: [:new, :create]

  resources :stories, only: [] do
    member do
      post :read
    end
  end

  root to: redirect('/search')
end
