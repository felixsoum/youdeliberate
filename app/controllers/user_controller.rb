class UserController < ApplicationController
  def index
    selected_narrative_id = params[:id]
    if !selected_narrative_id.nil? and !Narrative.exists?(selected_narrative_id)
      flash[:error] = "Shared narrative doesn't exist anymore"
      redirect_to root_path
    end
  end
end
