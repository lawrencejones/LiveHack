class TeamController < ApplicationController

  def 'teams_for_hack'
    @teams = Hackathon.find_by_eid(params[:eid]).teams
    respond_to do |format|
      render :json {:teams => @teams}
    end
  end

end
