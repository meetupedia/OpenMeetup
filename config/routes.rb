Openmeetup::Application.routes.draw do
  resources :groups, :shallow => true do
    resources :events do
      resources :participations, :shallow => true do
        collection do
          get :set
        end
      end
    end
    resources :memberships, :shallow => true do
      collection do
        get :set
      end
    end
  end

  resources :users

  match '/auth/:provider/callback' => 'sessions#create'
  match '/sign_in/:provider' => 'sessions#new', :as => :sign_in
  match '/sign_out' => 'sessions#destroy', :as => :sign_out
  root :to => 'root#index'
end
