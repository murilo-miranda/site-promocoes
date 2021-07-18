Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  resources :promotions, only: %i[index show new create destroy edit update] do
    post 'generate_coupon', on: :member
  end
end
