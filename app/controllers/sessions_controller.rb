class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to session[:return_to] || root_url, :notice => 'Sikeres bejelentkezés.'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Sikeres kijelentkezés.'
  end

  def sign_in
    session[:return_to] = params[:return_to]
  end
end
