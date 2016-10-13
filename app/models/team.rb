class Team < ActiveRecord::Base
  has_many :players
  before_save { self.name = name.upcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
end