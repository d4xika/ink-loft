Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/alive", to: "alive#alive"

  resources :users, only: [] do
    collection do
      get :is_logged_in
      post :login
      post :register
      put :logout
      put :update_profile
    end
  end

  resources :books, only: [ :index, :create, :show ] do
    collection do
      get :autocomplete
      get :currently_reading
    end
  end

  resources :quotes, only: [ :index, :create, :destroy, :update ] do
    collection do
      get :daily_quote
      end
  end
end
