class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      authentication.user.apply_omniauth(omniauth)
      authentication.user.save
      sign_in_and_redirect(authentication.user)
    elsif current_user
      current_user.authentications.create! :provider => omniauth['provider'], :uid => omniauth['uid']
      current_user.apply_omniauth(omniauth)
      current_user.save
      redirect_to root_url
    else
      user = User.new :name => omniauth['info']['name'], :email => omniauth['info']['email']
      user.authentications.build :provider => omniauth['provider'], :uid => omniauth['uid']
      user.apply_omniauth(omniauth)
      if user.save
        sign_in_and_redirect(user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to root_url
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to dashboard_user_path(current_user)
  end

private

  def sign_in_and_redirect(user)
    unless current_user
      session[:user_id] = user.id
    end
    redirect_to session[:return_to] || user
  end
end
