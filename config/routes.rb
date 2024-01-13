Rails.application.routes.draw do
<<<<<<< Updated upstream
  devise_for :users
=======
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'user_addresses', to: 'users/registrations#new_user_address'
    post 'user_addresses', to: 'users/registrations#create_user_address'
  end
>>>>>>> Stashed changes
  root to: "items#index"
  resources :items do
    resources :purchase_records, only: [:index, :create]
    resource :likes, only: [:create, :destroy]
    resources :comments, only: :create
  end
  resources :users, only: [:new, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
  end
  resources :cards, only: [:new, :edit, :update, :create, :destroy]
end
