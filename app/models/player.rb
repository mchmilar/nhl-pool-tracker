class Player < ActiveRecord::Base
  require 'csv'
  
  belongs_to :group
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      player_hash = row.to_hash
      Player.create!(player_hash)
    end
  end
end