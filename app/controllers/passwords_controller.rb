# encoding: UTF-8

class PasswordsController < CommonController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
  end

  def create
    unless params[:user][:email].blank?
      if @user = User.find_by_email(params[:user][:email])
        @user.deliver_password_reset
        flash[:notice] = 'E-mailben elküldtük a szükséges tennivalókat.'
        redirect_to root_url
      else
        flash[:alert] = 'Nincsen felhasználó ezzel az e-mail címmel!'
        render :new
      end
    else
      flash[:alert] = 'Kötelező e-mail címet megadnod!'
      render :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = 'Sikeres jelszóváltoztatás.'
      redirect_to root_url
    else
      render :edit
    end
  end

protected

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:alert] = 'Nem sikerült azonosítani téged, próbáld meg még egyszer!'
      redirect_to root_url
    end
  end
end
