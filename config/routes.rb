Rails.application.routes.draw do
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
  resources :users


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root 'application#hello'
end
