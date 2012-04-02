# -*- encoding : utf-8 -*-

Openmeetup::Application.routes.draw do
  resources :groups do
    member do
      get :invited
      get :users
    end
    resources :events, :shallow => true do
      resources :event_invitations, :shallow => true
      member do
        get :users
        get :invited
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
    resources :group_invitations, :shallow => true
    resources :memberships, :shallow => true do
      collection do
        get :set
      end
    end
    resources :reviews
  end

  resources :tags do
    resources :taggings, :shallow => true
  end

  resources :users do
    resources :user_follows, :shallow => true
    member do
      get :dashboard
      get :groups
    end
  end

  match '/about' => 'root#about', :as => :about
  match '/developer_dashboard' => 'root#developer_dashboard', :as => :developer_dashboard
  match '/search' => 'search#index', :as => :search
  match '/tag_myself' => 'root#tag_myself', :as => :tag_myself

  match '/auth/:provider/callback' => 'sessions#create'
  match '/sign_in/:provider' => 'sessions#new', :as => :sign_in
  match '/sign_out' => 'sessions#destroy', :as => :sign_out
  root :to => 'root#index'
end
