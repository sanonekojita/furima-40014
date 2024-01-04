Rails.application.routes.draw do
  devise_for :users
  root to: "items#index"
  resources :items do
    resources :purchase_records, only: [:index, :create]
  end
  resources :users, only: [:show, :edit, :update]
  resources :cards, only: [:new, :edit, :update, :create]
end
