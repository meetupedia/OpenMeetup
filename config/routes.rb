Openmeetup::Application.routes.draw do
  resources :events do
    resources :participations
  end

  resources :groups do
    resources :events
    resources :memberships
  end

  resources :memberships

  resources :participations

  resources :users

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout
  root :to => 'root#index'
end
