class Player < ActiveRecord::Base
  require 'csv'
  require 'open-uri'
  require 'json'
  require 'pry'
  
  belongs_to :group
  has_one :injury

  validates :name, presence: true
  
  STATS_SCRAPE_URL = 'http://www.nhl.com/stats/rest/skaters?isAggregate=false&reportType=basic&isGame=false&reportName=skatersummary&cayenneExp=gameTypeId=2%20and%20seasonId%3E=20172018%20and%20seasonId%3C=20172018'
  NAME_KEY = 'playerName'
  POINTS_KEY = 'points'
  GP_KEY = 'gamesPlayed'
  G_KEY = 'goals'
  A_KEY = 'assists'
  PPG_KEY = 'ppGoals'
  PPP_KEY = 'ppPoints'
  SHG_KEY = 'shGoals'
  SHP_KEY = 'shPoints'
  GWG_KEY = 'gameWinningGoals'
  SOG_KEY = 'shots'
  S_PCT_KEY = 'shootingPctg'
  ATOI_KEY = 'timeOnIcePerGame'
  NHLID_KEY = 'playerId'
  TEAMS_PLAYED_FOR_KEY = 'playerTeamsPlayedFor'
  GAMES_IN_SEASON = 82.0
  # get the group that picked the player
  def group
    Group.find(group_id)
  end

  def games_this_month
    Game.where("(away_team_id = ? or home_team_id = ?) and MONTH(game_date) = MONTH(CURRENT_DATE()) and game_date >= CURRENT_DATE()", team_id, team_id).size
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
    options = {stat: 'pts', order: 'desc', all_columns: false, for_chart: true}.merge(options)
    players = Player.where(draft_pos: draft_pos)
    players = players.order("#{options[:stat]} #{options[:order].upcase}")
    if options[:all_columns]
      return players 
    end
    puts "Initial Players from draft_class: "
    players.each {|player| puts "#{player.name}"}
    #strip individual player hash of unessessary key:value pairs
    players = players.to_a.map(&:serializable_hash)
    players.each do |player| 
      player[:y] = player[options[:stat]]
      gid = player['group_id']
      player['grp'] = Group.find(gid).name
      player.slice!('name', options[:stat], :y, 'grp')
      puts name
      player[:selected] = true  if player['name'] == name
    end
    puts "Players from draft_class after to_a: #{players}"
    return players
    # return an array of hashes unless it is wanted for a chart
    #return players unless options[:for_chart]
    #  players.map { |player| player.values }
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

  def self.check_player_teams
    players = Player.all
    #binding.pry
    # threads = []
    # 50.times do |i|
    #   threads[i] = Thread.new do
        
    #   end
    # end
    # threads.each { |thr| thr.join }

    threads = []
    players.each do |player|
      #threads << Thread.new {
        fixed_name = player.name.gsub(/\s/, '%20')
        #puts fixed_name
        url = "https://suggest.svc.nhl.com/svc/suggest/v1/minplayers/#{fixed_name}"
        result = JSON.parse(open(url).read)
        #puts result
        sz = result["suggestions"].size
        if result["suggestions"].size > 1
          count = 0
          result["suggestions"].each do |p|
            count += 1 if p.split("|")[3] == "1"
          end
          if count > 1 or result["suggestions"].size == 0
            p_result = result['suggestions']
            puts "\n #{player.name} \n #{player.team_id} \n #{sz} \n"
            #binding.pry
          end

        end
        #binding.pry if result.size != 1
      #}
      
    end
    #threads.each { |thr| thr.join }
  end

  # Should be moved to separate module?
  def self.update_stats
    players_stats = JSON.parse(open(STATS_SCRAPE_URL).read)
    failed_array = Array.new
    # iterate through each player and update their stats
    players_stats["data"].each do |player_stats|
      #binding.pry if player_stats[NAME_KEY] == "Sebastian Aho"
      player = Player.find_by(nhl_id: player_stats[NHLID_KEY])
      if player
        # NHL.COM REST API for stats gives a comma separated list of teams played for
        # in the current season. So we want the last team in this list.
        teams_played_for = player_stats[TEAMS_PLAYED_FOR_KEY].split(', ')
        team_id = Team.find_by(teamAbbrev: teams_played_for[teams_played_for.size - 1]).id
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
           atoi: player_stats[ATOI_KEY],
           nhl_id: player_stats[NHLID_KEY],
           team_id: team_id)
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
                              player_stats[ATOI_KEY],
                              player_stats[NHLID_KEY])
          failed_array << player_stats[NAME_KEY]
        end
      end
    end
    failed_array
  end

  # Should be moved to separate module?
  def self.add_player(name, gp, points, g, a, ppg, ppp, shg, shp, gwg, sog, s_pct, atoi, nhl_id)
    # If we already have a player with the same last name in our database
    # we will have to manually deal with the player as sometimes there are
    # differences in  how first names are expressed.
    # EG: P.A Parenteau / Pierre-Alexander Parenteau / PA Parenteau
    # name_a = name.split
    # logger.debug "Couldn't find player #{name}, attempting to create player in database"
    # player = Player.where("name like ?", "%#{name_a[name_a.length - 1]}")[0]
    # logger.debug "name like #{name_a[name_a.length - 1]} returns: #{player.name}"
    # return false if player
    binding.pry
    player = Player.create!(nhl_id: nhl_id, name: name, gp: gp, pts: points, goals: g, assists: a, ppg: ppg, ppp: ppp, shg: shg, shp: shp, gwg: gwg, shots: sog, s_pct: s_pct, atoi: atoi)
    if player
      logger.debug "Successfully created player #{name}"
      return true
    else
      logger.debug "Failed to create player #{name} with errors: #{player.errors.full_messages}"
      return false
    end

  end
end
