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

end
