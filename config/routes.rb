Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'user_addresses', to: 'users/registrations#new_user_address'
    post 'user_addresses', to: 'users/registrations#create_user_address'
  end
  root to: "items#index"
  resources :items do
    get 'tag_search', on: :collection
    resources :purchase_records, only: [:index, :create]
    resource :likes, only: [:create, :destroy]
    resources :comments, only: :create
  end
  resources :users, only: [:new, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
  end
  resources :cards, only: [:new, :edit, :update, :create, :destroy]
  resources :categories, only: [:new]
  get '/category/:id', to: 'categories#search'
end
