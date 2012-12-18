# encoding: UTF-8

class PasswordsController < CommonController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
  end

  def create
    unless params[:user][:email].blank?
      if @user = User.find_by_email(params[:user][:email])
        @user.deliver_password_reset
        flash[:notice] = tr('An email has been sent to you, check your Inbox for further instructions.')
        redirect_to root_url
      else
        flash[:alert] = tr('No user found with this email, please try another email address.')
        render :new
      end
    else
      flash[:alert] = tr('Please enter an email address.')
      render :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = tr('Password changed successfully, congratulations.')
      redirect_to root_url
    else
      render :edit
    end
  end

protected

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:alert] = tr('Something went wrong, please try again.')
      redirect_to root_url
    end
  end
end
