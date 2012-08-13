BooksShop::Application.routes.draw do
  resources :users
  resource :user_sessions
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  root :to => 'home#index'
end
