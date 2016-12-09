class TeamsController < ApplicationController
  

  TEAM_UPDATE_URL = 'http://www.nhl.com/stats/rest/grouped/team/basic/season/teamsummary?cayenneExp=seasonId=20162017%20and%20gameTypeId=2&factCayenneExp=gamesPlayed%3E=1&sort=[{%22property%22:%22wins%22,%22direction%22:%22DESC%22},{%22property%22:%22points%22,%22direction%22:%22DESC%22}]'

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new()
  end

  def create
    team = Team.new(team_params)
    if team.save
      flash[:success] = "Team: #{team.name}, successfully added!"
    else
      render 'new'
    end
    redirect_to teams_new_path
  end

  def update
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end
  
end
