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

  resources :books, only: [ :index, :create, :show ]

  resources :quotes, only: [ :index, :create ]
end
