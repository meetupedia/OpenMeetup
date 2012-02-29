Openmeetup::Application.routes.draw do
  resources :events do
    member do
      get :set_participation
    end
  end

  resources :groups do
    resources :events
    resources :memberships
    member do
      get :set_membership
    end
  end

  resources :memberships

  resources :participations

  resources :users

  match '/auth/:provider/callback' => 'sessions#create'
  match '/sign_in/:provider' => 'sessions#sign_in'
  match '/signout' => 'sessions#destroy', :as => :signout
  root :to => 'root#index'
end
