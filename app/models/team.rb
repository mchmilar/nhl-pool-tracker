require 'open-uri'
require 'json'

class Team < ActiveRecord::Base

  has_many :players
  has_many :away_teams, :class_name => 'Game', :foreign_key => 'away_team_id'
  has_many :home_teams, :class_name => 'Game', :foreign_key => 'home_team_id'

  before_save do
    self.teamFullName = teamFullName.titleize if teamFullName
    self.teamAbbrev = teamAbbrev.upcase if teamAbbrev
  end

  VALID_ABBREV_REGEX = /\A[a-zA-Z]{3}\z/i
  TEAM_UPDATE_URL = 'http://www.nhl.com/stats/rest/grouped/team/basic/season/teamsummary?cayenneExp=seasonId=20172018%20and%20gameTypeId=2&factCayenneExp=gamesPlayed%3E=0&sort=[{%22property%22:%22wins%22,%22direction%22:%22DESC%22},{%22property%22:%22points%22,%22direction%22:%22DESC%22}]'

  validates :teamFullName, presence: true, uniqueness: { case_sensitive: false }
  validates :teamAbbrev, presence: true,
            uniqueness: { case_sensitive: false },
            length: { is: 3 },
            format: { with: VALID_ABBREV_REGEX }



  def self.team_id_by_name(team_name)
    team = Team.find_by(teamFullName: team_name)
    team[:id]
  end
  # Use the team_stats array to update all team records
  # Should rollback all changes if any of the updates fail
  def self.do_teams_update(team_stats)

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
  def self.parse_team_stats
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


  # Updates team stats from nhl.com
  def self.update_teams()
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

  # Return a hash with teams abbrev who are playing tonight
    # as keys. Values are their opponents abbrev with an '@'
    # prefixed to an away teams opponents . It's a little redundant
    # storing each team twice but there can only ever be a max of
    # 15 games (31 teams in the league) so it has no performance
    # impact while simplfying implimentation with the hash
    def self.getActiveTonight()
      time = Time.new
      sched_url = 'https://statsapi.web.nhl.com/api/v1/schedule?startDate=%s&endDate=%s&leaderCategories=&leaderGameTypes=R&site=en_nhlCA&teamId=&gameType=&timecode='
      sched_url = sched_url % [time.strftime("%Y-%m-%d"), time.strftime("%Y-%m-%d")]
      sched_json = open(sched_url).read
      sched_json = JSON.parse(sched_json, symbolize_names: true)
      # sched json contains some keys the total game counts of 
      # the requested date range. the dates key is a an array
      # of all the requested dates. Since we only want one day
      # we select the first (and only) date. Inside that date is
      # the games key which is the array with our schedule info
      games_array = sched_json[:dates][0][:games]
      schedule = Hash.new
      games_array.each do |game|
          away = game[:teams][:away][:team][:name]
          home = game[:teams][:home][:team][:name]
          away_abbrev = Team.find_by(teamFullName: away).teamAbbrev
          home_abbrev = Team.find_by(teamFullName: home).teamAbbrev
          schedule[home_abbrev] = " vs %s" % [away_abbrev]
          schedule[away_abbrev] = " @ %s" % [home_abbrev]
      end
      schedule
  end

end