class AddTeamAbbreviationToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :team_abbrev, :string
  end
end
