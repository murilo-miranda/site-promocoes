Rails.application.routes.draw do
  root 'home#index'

  devise_for :admins
  resources :promotions, only: %i[index show new create destroy edit update] do
    post 'generate_coupon', on: :member
  end

  resources :coupon, onlu: %i[] do
    member do
      post 'inactivate'
      post 'active'
    end
  end
end
