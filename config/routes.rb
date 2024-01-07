Rails.application.routes.draw do
  devise_for :users
  root to: "items#index"
  resources :items do
    resources :purchase_records, only: [:index, :create]
    resource :likes, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
  end
  resources :cards, only: [:new, :edit, :update, :create, :destroy]
end
