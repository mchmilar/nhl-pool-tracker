class Player < ActiveRecord::Base
  require 'csv'
  require 'open-uri'
  require 'json'
  
  belongs_to :group
  
  STATS_SCRAPE_URL = 'http://www.sportsnet.ca/wp-admin/admin-ajax.php?action=leagues_players_get_data&league=nhl&position=skater&theme=genesis&season=2016'
  NAME_KEY = '18'
  POINTS_KEY = '5'
  GP_KEY = '2'
  GAMES_IN_SEASON = 82.0
  # get the group that picked the player
  def group
    Group.find(group_id)
  end
  
  # get the projected pts/gm
  def prjct_pts_game
    lwl_pts / GAMES_IN_SEASON
  end
  
  # get current pts/gm pace
  def pts_game
    return 0 if gp.nil? || pts.nil?
    (pts / gp).to_f
  end
  
  def team_name
    if team_id
      Team.find(team_id).name 
    else
      "None"
    end
  end
  
  def self.import(file)
    Player.destroy_all
    CSV.foreach(file.path, headers: true) do |row|
      player_hash = row.to_hash
      puts "Player Hash = #{player_hash}"
      team = Team.find_by(name: player_hash["team"].upcase)
      player_hash[:team_id] = team.id if team
      player_hash.except!("team")
      Player.create!(player_hash)
    end
  end
  
  def self.update_stats
    players_stats = JSON.parse(open(STATS_SCRAPE_URL).read)
    failed_array = Array.new
    # iterate through each player and update their stats
    players_stats.each do |player_stats|
      player = Player.find_by(name: player_stats[NAME_KEY])
      if player
        player.pts = player_stats[POINTS_KEY]
        player.gp = player_stats[GP_KEY]
        player.save
      else
        failed_array << player_stats[NAME_KEY]
      end
    end
    failed_array
  end
end