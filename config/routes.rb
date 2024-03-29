Rails.application.routes.draw do
  root 'home#index'

  devise_for :admins

  get 'search', to:'promotions#search'
  get 'search_coupon', to:'coupon#search'

  resources :product_categories, only: %i[index new create]

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
