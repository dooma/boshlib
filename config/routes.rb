BooksShop::Application.routes.draw do
  resources :books do
    collection do
      post :hire
    end
  end
  resources :users do
    member do
      get :activate
    end
  end
  resource :user_sessions
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  root :to => 'home#index'
end
