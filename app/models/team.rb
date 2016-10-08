class Team < ActiveRecord::Base
  has_many :players
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
end