class UserController < ApplicationController
  def index
  	@popover_contents = render_to_string(partial: "tutorial_popover")
    selected_narrative_id = params[:id]
    if !selected_narrative_id.nil? and !Narrative.exists?(selected_narrative_id)
      flash[:error] = "Shared narrative doesn't exist anymore"
      redirect_to root_path
    end
  end
end
