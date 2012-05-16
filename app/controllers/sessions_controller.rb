# -*- encoding : utf-8 -*-

class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
    user.update_attributes :token => auth['credentials']['token']
    unless auth[:provider] == 'developer'
      if user.facebook
        user.update_attributes :email => user.facebook.email if user.facebook.email
#        user.update_attributes :location => user.facebook.location if user.facebook.location
        user.update_attributes :facebook_friend_ids => user.facebook.friends.map { |friend| friend.identifier } if user.facebook.friends
      end
    end
    session[:user_id] = user.id
    redirect_to session[:return_to] || root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Sikeres kijelentkezés.'
  end

  def sign_in
    session[:return_to] = params[:return_to]
    redirect_to "/auth/#{params[:provider]}"
  end
end
