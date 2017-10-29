require 'open-uri'
require 'json'

class Game < ActiveRecord::Base
    belongs_to :away_team, :class_name => 'Team'
    belongs_to :home_team, :class_name => 'Team'

    validates :nhl_game_id, presence: true
    validates :link, presence: true
    validates :game_type, presence: true
    validates :season, presence: true
    validates :game_date, presence: true
    validates :away_team_id, presence: true
    validates :home_team_id, presence: true


    def self.pull_schedule(start_year, end_year, game_type)
        schedule_url = 'https://statsapi.web.nhl.com/api/v1/schedule?startDate=%s-09-01&endDate=%s-08-31&gameType=%s'        
        raise "start year must be before end year" if (start_year.to_i > end_year.to_i)
        raise "can only pull schedule for exactly one season" if ((end_year.to_i - start_year.to_i) != 1)
        raise "valid game types are PR, R, and P" unless (game_type.upcase == "PR" || game_type.upcase == "R" || game_type.upcase == "P")

        schedule_url = schedule_url % [start_year, end_year, game_type]
        sched_json = open(schedule_url).read
        sched_json = JSON.parse(sched_json, symbolize_names: true)
        
        ActiveRecord::Base.transaction do
            dates_array = sched_json[:dates]
            dates_array.each do |date_block|
                games_array = date_block[:games]
                games_array.each do |json_game|
                    db_game = Hash.new
                    db_game[:nhl_game_id] = json_game[:gamePk]
                    db_game[:link] = json_game[:link]
                    db_game[:game_type] = json_game[:gameType]
                    db_game[:game_date] = json_game[:gameDate]
                    db_game[:season] = start_year + end_year
                    db_game[:away_team_id] = Team.team_id_by_name(json_game[:teams][:away][:team][:name])
                    db_game[:home_team_id] = Team.team_id_by_name(json_game[:teams][:home][:team][:name])
                    logger.debug "Game: Attempting to create with Game: #{db_game}"
                    Game.create(db_game)
                end
            end
        end
    end
    
end
