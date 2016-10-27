class Player < ActiveRecord::Base
  require 'csv'
  require 'open-uri'
  require 'json'
  
  belongs_to :group

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
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
    return 0 if lwl_pts.nil?
    lwl_pts / GAMES_IN_SEASON
  end
  
  # get current pts/gm pace
  def pts_game
    return 0 if gp.nil? || pts.nil?
    (pts / gp.to_f)
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
        # If we are here then we weren't able to find the player in our database
        # We want to try to add the player and their stats to the database
        if !Player.add_player(player_stats[NAME_KEY], player_stats[GP_KEY], player_stats[POINTS_KEY])
          failed_array << player_stats[NAME_KEY]
        end
      end
    end
    failed_array
  end

  def self.add_player(name, gp, points)
    # If we already have a player with the same last name in our database
    # we will have to manually deal with the player as sometimes there are
    # differences in  how first names are expressed.
    # EG: P.A Parenteau / Pierre-Alexander Parenteau / PA Parenteau
    name_a = name.split
    logger.debug "Couldn't find player #{name}, attempting to create player in database"
    player = Player.where("name like ?", "%#{name_a[name_a.length - 1]}")[0]
    logger.debug "name like #{name_a[name_a.length - 1]} returns: #{player}"
    return false if player
    player = Player.create(name: name, gp: gp, pts: points)
    if player
      logger.debug "Successfully created player #{name}"
    else
      logger.debug "Failed to create player #{name} with errors: #{player.errors.full_messages}"
    end

  end
end