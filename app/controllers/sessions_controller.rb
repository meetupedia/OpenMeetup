# -*- encoding : utf-8 -*-

class SessionsController < ApplicationController

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Sikeres kijelentkezés.'
  end
end
