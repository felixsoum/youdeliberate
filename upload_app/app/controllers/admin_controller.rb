class AdminController < ApplicationController
  def home
  	@message = "Wanna upload?"
  end

  def upload
  	uploaded_io = params[:narrative]
  	File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
  		file.write(uploaded_io.read)
  	end
  end
end
