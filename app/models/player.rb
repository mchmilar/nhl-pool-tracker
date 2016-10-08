class Player < ActiveRecord::Base
  require 'csv'
  
  belongs_to :group
  belongs_to :team
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :lwl_pts, presence: true
  
  
  
  def group
    Group.find(group_id)
  end
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      player_hash = row.to_hash
      Player.create!(player_hash)
    end
  end
end