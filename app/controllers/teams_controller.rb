class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def new
    @team = Team.new(name: "mark")
  end

  def create
    team = Team.new(team_params)
    if team.save
      flash[:success] = "Team: #{team.name}, successfully added!"
    else
      render 'new'
    end
    redirect_to teams_path
  end
  
  def import
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end
end