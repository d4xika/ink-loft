Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/alive", to: "alive#alive"

  resources :users, only: [] do
    collection do
      post :login
      post :register
      put :update_profile
    end
  end

  resources :books, only: [ :index, :create, :show ] do
    collection do
      get :autocomplete
    end
  end

  resources :quotes, only: [ :index, :create, :destroy, :update ] do
    collection do
      get :daily_quote
      end
  end
end
