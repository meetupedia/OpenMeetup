class AuthenticationsController < ApplicationController

  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      authentication.user.apply_omniauth(omniauth)
      sign_in_and_redirect(authentication.user)
    elsif current_user
      current_user.authentications.create! :provider => omniauth['provider'], :uid => omniauth['uid']
      current_user.apply_omniauth(omniauth)
      redirect_to discovery_url
    else
      user = User.new :name => omniauth['info']['name'], :email => omniauth['info']['email']
      user.authentications.build :provider => omniauth['provider'], :uid => omniauth['uid']
      if user.save
        user.apply_omniauth(omniauth)
        session[:return_to] = tag_myself_url
        sign_in_and_redirect(user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to sign_in_path
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
      user_session = UserSession.new(User.find_by_single_access_token(user.single_access_token))
      user_session.save
    end
    redirect_to session[:return_to] || discovery_url
  end
end
