class Group < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'
  
  has_many :players
  
  validates :name, presence: true, uniqueness: {case_sensitive: false }
  validates :op_id_number, presence: true, uniqueness: { case_sensitive: false }
  
  BASE_PLAYER_URL = "http://www.officepools.com/nhl/entity/player/"
  
  def self.batch_import(pool_data_uri)
    Group.destroy_all
    groups = get_op_groups(pool_data_uri)
    failed_player_adds = Array.new
    
    # Iterate through each group in the pool
    groups.each_pair do |op_group_id, op_group_name|
      op_player_ids = get_op_group_players("#{pool_data_uri}/#{op_group_id}.js")
      group = Group.new(name: op_group_name, op_id_number: op_group_id)
      
      if group.save
        op_player_ids.each do |op_player_id|
          # Assign player to group. If this fails, add it to the list of failed adds
          failed_player_adds << "Player: #{op_player_id} to Group: #{op_group_id}" if !add_player_to_group(op_player_id, Group.last.id)
        end
      end
    end
    failed_player_adds
  end
  
  def players
    Player.where(group_id: id)
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
  
  def self.hash
    groups = Group.all
    groups_hash = Hash.new
    groups.each do |group|
      groups_hash[group.id] = { name: group.name, op_id_number: group.op_id_number, players: group.players, max_pts: group.max_proj_pts, min_pts: group.min_proj_pts }
    end
    groups_hash
  end
    
private
  def self.get_op_groups(uri)
    res = open(uri).read.split("pointsMonth")[1]
    groups_array = res.scan(/\d{7}\|[\w\d_\s\.&\-]+/)
    groups_hash = Hash.new
    groups_array.each do |group|
      group = group.split("|")
      groups_hash[group[0]] = group[1] 
    end
    groups_hash
  end
  
  def self.get_op_group_players(uri)
    res = open(uri).read
    players = res.scan(/p\d{4}/)
    players.each { |player| player.slice!("p") }
  end
  
  def self.add_player_to_group(player_id, group_id)
    url = "#{BASE_PLAYER_URL}#{player_id}"
    #byebug
    name = parse_player_name(Nokogiri::HTML(open(url)))
    player = Player.where("lower(name) = ?", name.downcase).first
    if player
      player.group_id = group_id
      player.save
    else
      false
    end
  end
  
  def self.parse_player_name(html_response)
    output = html_response.css('h1#page-title')[0].text.split("#")[0][18..-1].split(",")
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