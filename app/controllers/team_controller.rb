class TeamController < ApplicationController

  def 'teams_for_hack'
    @teams = Hackathon.find_by_eid(params[:eid]).teams
    respond_to do |format|
      render :json {:teams => @teams}
    end
  end

  def show
    @team = Team.find params[:id]
    @users = @team.users.all
    @proposals = @team.proposals.all
    respond_to do |format|
      format.json render :json {:team => @team, :users => @users, :proposals => @proposals}
    end
  end

end
