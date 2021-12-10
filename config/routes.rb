Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'items/find', to: 'items_search#find'
      get 'items/find_all', to: 'items_search#find_all'
      get 'merchants/find', to: 'merchants_search#find'
      get 'merchants/find_all', to: 'merchants_search#find_all'
      resources :merchants, only: %i[index show] do
        resources :items, action: :index, controller: 'merchant_items'
      end
      resources :items do
        resources :merchant, action: :show, controller: 'merchant_items'
      end
    end
  end
end
