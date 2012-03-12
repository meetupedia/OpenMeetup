Openmeetup::Application.routes.draw do
  resources :groups, :shallow => true do
    member do
      get :users
    end
    resources :events do
      member do
        get :users
      end
      resources :participations, :shallow => true do
        collection do
          get :set
        end
      end
    end
    resources :follows, :shallow => true do
      collection do
        get :set
      end
    end
    resources :memberships, :shallow => true do
      collection do
        get :set
      end
    end
    resources :reviews
  end

  resources :users do
    member do
      get :dashboard
    end
  end

  match '/about' => 'root#about', :as => :about
  match '/developer_dashboard' => 'root#developer_dashboard', :as => :developer_dashboard

  match '/auth/:provider/callback' => 'sessions#create'
  match '/sign_in/:provider' => 'sessions#new', :as => :sign_in
  match '/sign_out' => 'sessions#destroy', :as => :sign_out
  root :to => 'root#index'
end
