module SessionsHelper

  def sign_in admin
    cookies[:user_id] = admin.id
  end

  def signed_in?
    !cookies[:user_id].nil?
  end

  def sign_out
    cookies.delete(:user_id)
  end
  
end
