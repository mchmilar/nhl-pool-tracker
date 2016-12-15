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
  G_KEY = '3'
  A_KEY = '4'
  PPG_KEY = '7'
  PPP_KEY = '8'
  SHG_KEY = '10'
  SHP_KEY = '11'
  GWG_KEY = '12'
  SOG_KEY = '14'
  S_PCT_KEY = '15'
  ATOI_KEY = '16'
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
  
  def team_abbrev
    if team_id
      Team.find(team_id).teamAbbrev
    else
      "None"
    end
  end

  # Expected final point total at the end of the year
  def efp
    (pts + prjct_pts_game * remaining_games).round(0)
  end

  # Number of remaining games left
  def remaining_games
    (team_id) ? 82 - Team.find(team_id).gamesPlayed : 0
  end

  # Performance versus expected
  def pve
    (pts - (prjct_pts_game * gp)).round(2)
  end

  # Get all players taken in the same round
  def draft_class(options={})
    options = {stat: 'pts', order: 'desc', all_columns: false}.merge(options)
    players = Player.where(draft_pos: draft_pos)

    if options[:all_columns]
      return players.order("#{options[:stat]} #{options[:order].upcase}") 
    end
    players.to_a.map(&:serializable_hash).each {|player| player.slice!('name', options[:stat])}

  end
  
  def take_snapshot
    stats = {
      player_id: id,
      team_id: team_id,
      pts: pts,
      gp: gp,
      goals: goals,
      assists: assists,
      ppp: ppp,
      ppg: ppg,
      shg: shg,
      shp: shp,
      shots: shots,
      s_pct: s_pct,
      atoi: atoi,
      date: Time.now.to_s[0,10]
    }

    # If a player already has an entry for this date we update it
    player_history = PlayerStatHistory.where(player_id: id, date: Time.now.to_s[0,10])
    (player_history.length == 0) ? (PlayerStatHistory.create(stats)) : (player_history[0].update(stats))
  end

  # Should be moved to separate module?
  def self.batch_snapshot
    players = Player.all
    players.each { |player| player.take_snapshot }
  end

  # Should be moved to separate module?
  def self.import(file)
    Player.destroy_all
    CSV.foreach(file.path, headers: true) do |row|
      player_hash = row.to_hash
      puts "Player Hash = #{player_hash}"
      team = Team.find_by(teamAbbrev: player_hash["team"].upcase)
      player_hash[:team_id] = team.id if team
      player_hash.except!("team")
      Player.create!(player_hash)
    end
  end
  
  # Should be moved to separate module?
  def self.update_stats
    players_stats = JSON.parse(open(STATS_SCRAPE_URL).read)
    failed_array = Array.new
    # iterate through each player and update their stats
    players_stats.each do |player_stats|
      player = Player.find_by(name: player_stats[NAME_KEY])
      if player
        player.update(gp: player_stats[GP_KEY],
           pts: player_stats[POINTS_KEY],
           goals: player_stats[G_KEY],
           assists: player_stats[A_KEY],
           ppg: player_stats[PPG_KEY],
           ppp: player_stats[PPP_KEY],
           shg: player_stats[SHG_KEY],
           shp: player_stats[SHP_KEY],
           gwg: player_stats[GWG_KEY],
           shots: player_stats[SOG_KEY],
           s_pct: player_stats[S_PCT_KEY],
           atoi: player_stats[ATOI_KEY])
      else
        # If we are here then we weren't able to find the player in our database
        # We want to try to add the player and their stats to the database
        if !Player.add_player(player_stats[NAME_KEY],
                              player_stats[GP_KEY],
                              player_stats[POINTS_KEY],
                              player_stats[G_KEY],
                              player_stats[A_KEY],
                              player_stats[PPG_KEY],
                              player_stats[PPP_KEY],
                              player_stats[SHG_KEY],
                              player_stats[SHP_KEY],
                              player_stats[GWG_KEY],
                              player_stats[SOG_KEY],
                              player_stats[S_PCT_KEY],
                              player_stats[ATOI_KEY])
          failed_array << player_stats[NAME_KEY]
        end
      end
    end
    failed_array
  end

  # Should be moved to separate module?
  def self.add_player(name, gp, points, g, a, ppg, ppp, shg, shp, gwg, sog, s_pct, atoi)
    # If we already have a player with the same last name in our database
    # we will have to manually deal with the player as sometimes there are
    # differences in  how first names are expressed.
    # EG: P.A Parenteau / Pierre-Alexander Parenteau / PA Parenteau
    name_a = name.split
    logger.debug "Couldn't find player #{name}, attempting to create player in database"
    player = Player.where("name like ?", "%#{name_a[name_a.length - 1]}")[0]
    logger.debug "name like #{name_a[name_a.length - 1]} returns: #{player}"
    return false if player
    player = Player.create(name: name, gp: gp, pts: points, goals: g, assists: a, ppg: ppg, ppp: ppp, shg: shg, shp: shp, gwg: gwg, shots: sog, s_pct: s_pct, atoi: atoi)
    if player
      logger.debug "Successfully created player #{name}"
    else
      logger.debug "Failed to create player #{name} with errors: #{player.errors.full_messages}"
    end

  end
end