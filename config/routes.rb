Openmeetup::Application.routes.draw do
  resources :events

  resources :groups do
    resources :events
  end

  resources :users

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout
  root :to => 'root#index'
end
