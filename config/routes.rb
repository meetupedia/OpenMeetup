# encoding: UTF-8

Openmeetup::Application.routes.draw do
  mount WillFilter::Engine => '/will_filter'
  mount Tr8n::Engine => '/tr8n'
  mount GroupMailer::Preview => '/group_mailer/mail_view'
  mount UserMailer::Preview => '/user_mailer/mail_view'

  resources :groups do
    member do
      get :events
      get :images
      get :invited
      get :members
      get :waves
    end
    resources :comments, :shallow => true
    resources :events, :shallow => true do
      member do
        get :images
        get :invited
        get :map
        get :users
      end
      resources :absences, :shallow => true do
        collection do
          get :set
        end
      end
      resources :comments, :shallow => true
      resources :event_invitations, :shallow => true
      resources :images, :shallow => true
      resources :participations, :shallow => true do
        collection do
          get :set
        end
      end
    end
    resources :group_invitations, :shallow => true
    resources :images, :shallow => true
    resources :memberships, :shallow => true do
      collection do
        get :set
      end
      member do
        put :set_admin
        put :unset_admin
      end
    end
    resources :reviews, :shallow => true
    resources :tags, :shallow => true do
      resources :taggings, :shallow => true
    end
  end

  resources :interests do
    resources :interest_taggings, :shallow => true
  end

  resources :passwords
  resource :user_sessions

  resources :tags

  resources :users do
    resources :user_follows, :shallow => true
    collection do
      get :request_invite
      get :validate_email
    end
    member do
      get :edit_city
      get :activities
      get :facebook_groups
      get :groups
      get :settings
      get :waves
    end
  end

  resources :waves do
    resources :wave_items
  end

  match '/about' => 'root#about', :as => :about
  match '/developer_dashboard' => 'root#developer_dashboard', :as => :developer_dashboard
  match '/search' => 'search#index', :as => :search
  match '/dashboard' => 'root#dashboard', :as => :dashboard
  match '/restricted_access' => 'root#restricted_access', :as => :restricted_access

  match '/discovery' => 'discovery#index', :as => :discovery

  match '/system' => 'system#index', :as => :system
  match '/reload' => 'system#reload', :as => :reload
  match '/download_database' => 'system#download_database', :as => :download_database

  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'
  match '/sign_in' => 'user_sessions#new', :as => :sign_in
  match '/sign_out' => 'user_sessions#destroy', :as => :sign_out

  root :to => 'root#index'
  match ':controller(/:action(/:id))(.:format)'
end
