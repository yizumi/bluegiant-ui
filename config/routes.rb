# frozen_string_literal: true

Rails.application.routes.draw do
  root 'root#index'
  resources :exchanges, only: [:index, :create, :show] do
    resources :markets, only: [:index, :create]
  end
end
