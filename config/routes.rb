# frozen_string_literal: true

Rails.application.routes.draw do
  root 'root#index'
  resources :exchanges, only: %i[index create show] do
    resources :markets, only: %i[index create]
  end
end
