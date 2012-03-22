# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  def new
    session[:return_to] = params[:return_to]
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
    user.update_attributes :token => auth['credentials']['token']
    session[:user_id] = user.id
    redirect_to session[:return_to] || root_url, :notice => 'Sikeres bejelentkezés.'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Sikeres kijelentkezés.'
  end
end
