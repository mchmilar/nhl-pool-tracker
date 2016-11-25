class AddShootoutGamesWonToTeam < ActiveRecord::Migration
  def change
  	add_column :teams, :shootoutGamesWon, :integer
  end
end
