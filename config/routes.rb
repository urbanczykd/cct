Rails.application.routes.draw do
  resources :friendships, :only => [:create, :destroy]
  resources :users, :only => [:index] do
    resources :payments, :only => [:index, :new, :create] do
      member do
        get 'check'
      end
    end
  end
  devise_for :users

  root to: 'home#welcome'
end
