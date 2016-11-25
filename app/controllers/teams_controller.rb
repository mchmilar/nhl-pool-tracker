class TeamsController < ApplicationController
  require 'open-uri'
  require 'json'

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

  def do_update
    if update_teams
      flash.now[:success] = "Successfully updated teams!"
    else
      flash.now[:danger] = "Error updating teams."
    end
    render 'update'
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end

  # Updates team stats from nhl.com
  def update_teams()
    team_stats = parse_team_stats
    if team_stats
      # team_stats is a hash with only one key, :data, which is an array with
      # hashes as elements. Each hash in this array is an individual team's stats
      team_stats = team_stats[:data]
      begin
        do_teams_update(team_stats)
      rescue
        logger.debug "Error updating team records, aborting update_teams"
        return false
      end
    else
      logger.debug "Error parsing team stats, abortinng update_teams"
      return false
    end
    # Successfully updated teams
    true
  end


  # Use the team_stats array to update all team records
  # Should rollback all changes if any of the updates fail
  def do_teams_update(team_stats)

    team_in_db = Hash.new

    team_stats.each do |team_hash|
      team_abrv = team_hash[:teamAbbrev]
      if Team.find_by(teamAbbrev: team_abrv)
        team_in_db[team_abrv] = true
      else
        team_in_db[team_abrv] = false
      end
    end

    # Rolls back all changes if any one update fails
    ActiveRecord::Base.transaction do
      team_stats.each do |team_hash|
        team_hash.delete(:teamId)
        team_abrv = team_hash[:teamAbbrev]
        # If team is already in database, update stats
        if team_in_db[team_abrv]
          logger.debug "Team: #{team_abrv} found, attempting update"
          team_updating = Team.find_by(teamAbbrev: team_abrv)
          logger.debug "team_hash.length = #{team_hash.length}"
          logger.debug "Team.column_names = #{Team.column_names}"
          team_updating.update(team_hash)
          logger.debug "Team: #{team_abrv} successfully updated"
          # Else, team is not in database. Create it with stats
        else
          logger.debug "Team: #{team_abrv} not found, attempting to create with team_hash: #{team_hash}"
          Team.create(team_hash)
          logger.debug "Team: #{team_abrv} successfully created"
        end
      end
    end
  end

  # Opens our TEAM_UPDATE_URL and returns the parsed JSON as a hash
  # with keys symbolized
  def parse_team_stats
    teams_json= nil

    # Handle any exception caused by opening the stats url
    begin
      teams_json = open(TEAM_UPDATE_URL).read
    rescue
      logger.debug "Error opening and reading nhl.com team states url: #{TEAM_UPDATE_URL}"
      return false
    end
    JSON.parse(teams_json, symbolize_names: true)
  end
end
