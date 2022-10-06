Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  # get 'users/new'
  root 'static_pages#home'
  # changed the below in 5.3.2 to follow the model below the comments
  # get 'static_pages/home'
  # get 'static_pages/help'
  # get  'static_pages/about'
  # get  'static_pages/contact'
  get '/help', to: 'static_pages#help' #,  # as:'helf'  use this to make an alternative name for the path
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do #pg 855 
    member do
      get :following, :followers
    end
  end

  # this is the other possibility that gets the url without the id
  # resources :users do
  #   collection do
  #     get :tigers
  #   end
  # end
  # 
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update] #pg 680
  resources :microposts, only: [:create, :destroy] #pg 758
  resources :relationships, only: [:create, :destroy] #pg 861

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root 'application#hello'
end
