class Group < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'
  
  has_many :players
  
  BASE_PLAYER_URL = "http://www.officepools.com/nhl/entity/player/"
  
  def self.batch_import(pool_data_uri)
    group_ids = get_op_group_ids(pool_data_uri)
    temp_player_id = nil
    
    # Iterate through each group in the pool
    group_ids.each do |op_group_id|
      player_ids = get_op_group_players("#{pool_data_uri}/#{op_group_id}.js")
      group = Group.new(name: "NAME", op_id_number: op_group_id)
      if group.save
        player_ids.each do |player_id|
          add_player_to_group(player_id, Group.last.id)
        end
      end
    end
    
    add_op_player("4241")
  end
    
private
  def self.get_op_group_ids(uri)
    res = open(uri).read.split("pointsMonth")[1]
    res.scan(/\d{7}/)
  end
  
  def self.get_op_group_players(uri)
    res = open(uri).read
    players = res.scan(/p\d{4}/)
    players.each { |player| player.slice!("p") }
  end
  
  def self.add_player_to_group(player_id, group_id)
    name = parse_player_name(Nokogiri::HTML(open(BASE_PLAYER_URL << player_id)))
    player = Player.where("lower(name) = ?", name).first
    player.group_id = group_id
    player.save
  end
  
  def self.parse_player_name(html_response)
    output = html_response.css('h1#page-title')[0].text.split("#")[0][18..-1].split(",")
    output[1].strip << " " << output[0]
  end
end