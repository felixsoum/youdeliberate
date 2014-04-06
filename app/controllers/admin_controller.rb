class AdminController < ApplicationController
  include ZipHelper

  # POST admin/upload
  def upload
    narratives_zip = params[:narrative]
    if narratives_zip.nil?
      flash[:error] = "Failed. Nothing to upload."
    elsif narratives_zip.content_type != "application/zip" and
          narratives_zip.content_type != "application/octet-stream" and
          narratives_zip.content_type != "application/x-zip-compressed"
      # The MIME type of a zip file is sometimes octet-stream. Read more: http://stackoverflow.com/questions/856013/mime-type-for-zip-file-in-google-chrome
      flash[:error] = "Failed. Please choose a zip file."
    else
      require 'rubygems'
      require 'zip'
      require "mp3info"
      upload_narratives(narratives_zip)
    end
    redirect_to admin_list_path
  end

  def change_password
    admin = Admin.find(cookies[:user_id])
    if(admin.update(password: params[:password], password_confirmation: params[:password_confirmation]))
      flash[:success] = "Your password has been changed."
    else
      flash[:error] = "Please make sure the passwords you typed are the same."
    end
    redirect_to admin_setting_path
  end

  def add_admin
    admin = Admin.new(user_name: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if(admin.save)
      flash[:success] = "The new administrator has been added successfully."
    else
      flash[:error] = "The administrator is not added."
    end
    redirect_to admin_setting_path
  end

end
