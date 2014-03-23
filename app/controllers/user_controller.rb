class UserController < ApplicationController
  def index
  	@popover_contents = render_to_string(partial: "tutorial_popover")
  end
end
