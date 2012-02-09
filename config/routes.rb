Openmeetup::Application.routes.draw do
  resources :groups

  resources :users

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout
  root :to => 'root#index'
end
