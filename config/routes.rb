# encoding: UTF-8

Openmeetup::Application.routes.draw do

  mount WillFilter::Engine => '/will_filter'
  mount Tr8n::Engine => '/tr8n'
  # if Rails.env == 'production'
  # end

  mount CommentMailer::Preview => '/comment_mailer/mail_view'
  mount EventInvitationMailer::Preview => '/event_invitation_mailer/mail_view'
  mount EventMailer::Preview => '/event_mailer/mail_view'
  mount GroupInvitationMailer::Preview => '/group_invitation_mailer/mail_view'
  mount GroupMailer::Preview => '/group_mailer/mail_view'
  mount LetterMailer::Preview => '/letter_mailer/mail_view'
  mount MembershipRequestMailer::Preview => '/membership_request_mailer/mail_view'
  mount PostMailer::Preview => '/post_mailer/mail_view'
  mount UserMailer::Preview => '/user_mailer/mail_view'
  mount WaveMailer::Preview => '/wave_mailer/mail_view'

  namespace :admin do
    resources :users
  end

  resources :cities do
    member do
      get :search
    end
    collection do
      post :jump
    end
  end

  resources :groups do
    member do
      get :events
      get :images
      get :invited
      get :members
      get :requested_members
      get :waves
    end
    resources :posts, :shallow => true
    resources :events, :shallow => true do
      member do
        get :actual
        get :images
        get :invited
        get :map
        get :participations
        get :reviews
        get :users
        get :users_with_emails
      end
      resources :absences, :shallow => true do
        collection do
          get :set
        end
      end
      resources :comments, :shallow => true
      resources :event_invitations, :shallow => true
      resources :images, :shallow => true do
        collection do
          post :upload
        end
      end
      resources :participations, :shallow => true do
        member do
          post :checkin
        end
        collection do
          get :set
        end
      end
      resources :questions, :shallow => true
      resources :reviews, :shallow => true
    end
    resources :group_invitations, :shallow => true
    resources :images, :shallow => true do
      collection do
        post :upload
      end
    end
    resources :membership_requests, :shallow => true do
      member do
        put :confirm
      end
    end
    resources :memberships, :shallow => true do
      collection do
        get :set
      end
      member do
        put :set_admin
        put :unset_admin
      end
    end
    resources :tags, :shallow => true do
      resources :taggings, :shallow => true
    end
  end

  resources :interests do
    resources :interest_taggings, :shallow => true
  end

  resources :letter_templates do
    member do
      post :create_letter
    end
  end

  resources :letters do
    member do
      post :mail
      post :mailtest
    end
  end

  resources :notifications

  resources :passwords

  resources :posts do
    resources :comments, :shallow => true
  end

  resources :settings

  resources :tags

  resource :user_sessions

  resources :users do
    resources :user_follows, :shallow => true
    collection do
      get :request_invite
      get :validate_email
    end
    member do
      get :calendar
      get :edit_city
      get :facebook_groups
      get :groups
      post :set_admin
      post :unset_admin
      get :settings
      get :waves
    end
  end

  resources :waves do
    resources :wave_items
  end

  match '/about' => 'root#about', :as => :about
  match '/developer_dashboard' => 'root#developer_dashboard', :as => :developer_dashboard
  match '/discovery' => 'root#discovery', :as => :discovery
  match '/search' => 'search#index', :as => :search
  match '/dashboard' => 'root#dashboard', :as => :dashboard
  match '/restricted_access' => 'root#restricted_access', :as => :restricted_access

  match '/system-settings' => 'dashboard#index', :as => :system
  match '/reload' => 'dashboard#reload', :as => :reload
  match '/download_database' => 'dashboard#download_database', :as => :download_database

  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'
  match '/sign_in' => 'root#sign_in', :as => :sign_in
  match '/sign_in_with_email' => 'users#new', :as => :sign_in_with_email
  match '/sign_out' => 'user_sessions#destroy', :as => :sign_out

  root :to => 'root#index'
  match ':controller(/:action(/:id))(.:format)'
  match '/:id' => 'root#undefined', :as => :undefined
end
