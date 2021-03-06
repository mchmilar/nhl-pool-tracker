class Group < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'
  
  has_many :players
  
  validates :name, presence: true, uniqueness: {case_sensitive: false }
  validates :op_id_number, presence: true, uniqueness: { case_sensitive: false }
  
  BASE_PLAYER_URL = "https://www.officepools.com/nhl/entity/player/"
  NUM_PLAYERS_PER_GROUP = 12
  NUM_PLAYERS_SELECTED_FOR_SCORING = 10
  
  def self.batch_import(pool_data_uri)
    Group.destroy_all
    groups = get_op_groups(pool_data_uri)
    failed_player_adds = Array.new
    
    # Iterate through each group in the pool
    logger.debug "Beginning parsing of groups: #{groups}"
    groups.each do |op_group_id, op_group_name|
      op_player_ids = get_op_group_players("#{pool_data_uri}/#{op_group_id}.js")
      group = Group.new(name: op_group_name, op_id_number: op_group_id)
      
      if group.save
        op_player_ids.each do |op_player|
          # Assign player to group. If this fails, add it to the list of failed adds
          logger.debug "Attempting to add player: #{op_player}"
          if !add_player_to_group(op_player["id"], Group.last.id, op_player["drft_pos"])
            failed_player_adds << "Player: #{op_player["id"]} to Group: #{op_group_id}"
            logger.debug "Failed to assign player #{op_player["id"]} with draft position #{op_player["drft_pos"]} to Group #{op_group_id}"
          end
        end
      end
    end
    failed_player_adds
  end
  
  def players
    Player.where(group_id: self.id)
  end

  def top_players
    players = Player.where(group_id: self.id).sort_by { |player| -player.pts }
    players = players.take(NUM_PLAYERS_SELECTED_FOR_SCORING)
  end

  # Group point total
  def total_points
    self.players.inject(0) do |sum, player|
      player[:pts].nil? ? 0 : sum + player[:pts]
    end
  end

  def top_points
    self.top_players.inject(0) do |sum, player|
      player[:pts].nil? ? 0 : sum + player[:pts]
    end
  end

  def total_games
    self.players.inject(0) do |sum, player|
      player.gp.nil? ? 0 : sum + player.gp
    end
  end

  def top_games
    self.top_players.inject(0) do |sum, player|
      player.gp.nil? ? 0 : sum + player.gp
    end
  end

  def points_per_game
    self.total_points / self.total_games.to_f
  end

  def top_points_per_game
    self.top_points / self.top_games.to_f
  end
  
  def max_proj_pts
    sum = 0
    points = player_pts.sort!
    (2..points.length - 1).each { |i| sum += points[i] }
    sum
  end
  
  def min_proj_pts
    sum = 0
    points = player_pts.sort!
    (0..points.length - 3).each { |i| sum += points[i] }
    sum
  end
  
  def self.sorted_array
    Group.all.sort_by { |group| -group.top_points }
  end

  def self.sorted_hash
    groups = Group.all
    groups_hash = Hash.new
    groups.each do |group|
      groups_hash[group.id] = { name: group.name, op_id_number: group.op_id_number, players: group.players, max_pts: group.max_proj_pts, min_pts: group.min_proj_pts }
    end
    groups_hash.sort_by { |k, v| v[:name] }
  end

  # Expected final point total of group
  def efp
    top_players.inject(0) { |sum, player| player.efp + sum }
  end
    
private

  # Parse an Office Pool's JS string returned from an HTTP get containing pool data
  # Returns a hash with key, value pairs of Group ID => Team Name
  def self.get_op_groups(uri)
    # discard the part of the string that comes before 'pointsMonth'
    # this simplifies finding the team id's
    res = open(uri).read.split("pointsMonth")[1]
    
    #Creates an array in the format GoupID|TeamName
    groups_array = res.scan(/\d{7}\|[\w\d_\s\.&\-]+/)
    groups_hash = Hash.new
    
    groups_array.each do |group|
      # Split the id/name entries using | and then create the hash entry with the results
      group = group.split("|")
      groups_hash[group[0]] = group[1] 
    end
    groups_hash
  end
  
  # Use an Office Pool's url for an individual group to get a JS string containing player info
  # Parse and return an array that contains hash entries of the form {"id" => 33, "drft_pos" => 1}
  def self.get_op_group_players(uri)
    res = open(uri).read
    player_ids = res.scan(/p\d{1,4}/).each { |id| id.slice!("p") }
    draft_positions = res.scan(/(\d+)(?=(\|p))/)
    players = Array.new
    (0..NUM_PLAYERS_PER_GROUP - 1).each do |i| 
      id = player_ids[i]
      draft_pos = draft_positions[i][0]
      players.push({"id" => id, "drft_pos" => draft_pos})
      logger.debug "found draft position #{draft_pos}"
    end
    players
  end
  
  def self.add_player_to_group(player_id, group_id, draft_pos)
    url = "#{BASE_PLAYER_URL}#{player_id}"
    #byebug

    # Handle any exceptions while opening player url
    player_page = nil
    begin
      player_page = open(url)
    rescue
      logger.debug "Error opening #{url}"
      return false
    end

    name = parse_player_name(Nokogiri::HTML(player_page))
    player = Player.where("lower(name) = ?", name.downcase).first
    if player
      player.group_id = group_id
      player.draft_pos = (draft_pos.to_i + 1).to_s
      logger.debug "Saving player #{name} to group #{group_id} at draft position #{draft_pos}"
      if !player.save
        logger.debug "Unable to save player: '#{name}'. Old id=#{player.goup_id}, attempted new id=#{group_id}. Old draft_pos=#{player.draft_pos}, attempted new draft_pos=#{draft_pos}"
        return false
      end
    else
      logger.debug "No player: '#{name}'. Skipping"
      return false
    end
    return true
  end
  
=begin
<h1 id="page-title">
                                        Stats for player Karlsson, Erik #65 (D)  - Ottawa Senators - NHL 2017/18 Regular
                                    </h1>
=end

  def self.parse_player_name(html_response)
    output = html_response.css('h1#page-title')[0].text.split("player ")[1].split("#")[0].split(", ")
    output[1].strip << " " << output[0]
  end
  
  def player_pts
    points = Array.new
    players.each do |player|
      points << player.lwl_pts
    end
    points
  end
end