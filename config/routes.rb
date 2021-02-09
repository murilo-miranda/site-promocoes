Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  devise_for :users

  resources :promotions do
    member do
      post 'generate_coupons'
      patch 'approve'
    end
  end

  resources :coupons, only: [] do
    post 'inactivate', on: :member
  end
end
