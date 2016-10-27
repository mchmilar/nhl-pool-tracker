class Team < ActiveRecord::Base

  has_many :players
  before_save do
    self.teamFullName = teamFullName.titleize if teamFullName
    self.teamAbbrev = teamAbbrev.upcase if teamAbbrev
  end

  VALID_ABBREV_REGEX = /\A[a-zA-Z]{3}\z/i

  validates :teamFullName, presence: true, uniqueness: { case_sensitive: false }
  validates :teamAbbrev, presence: true,
            uniqueness: { case_sensitive: false },
            length: { is: 3 },
            format: { with: VALID_ABBREV_REGEX }



end