Rails.application.routes.draw do
  root 'home#index'

  devise_for :admins
  get 'search', to:'promotions#search'
  resources :promotions, only: %i[index show new create destroy edit update] do
    member do
      post 'generate_coupon'
      patch 'approve'
    end
  end

  resources :coupon, onlu: %i[] do
    member do
      post 'inactivate'
      post 'active'
    end
  end
end
