class SessionsController < ApplicationController

  def new
  end

  def create
    admin = Admin.find_by(user_name: params[:session][:email].downcase)
    if admin && admin.authenticate(params[:session][:password])
      sign_in admin #set cookies
      redirect_to admin_list_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out #delete cookies
    redirect_to signin_path
  end

  def forget_password
  end

  def send_password
    if (Admin.find_by user_name: params[:email])
      FlagMailer.forget_password_email(params[:email]).deliver
      flash[:success] = 'The password is sent to your email'
      redirect_to signin_path
    else
      flash[:error] = 'The user name does not exist.'
      redirect_to forget_password_path
    end
  end
end
