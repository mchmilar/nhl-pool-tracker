class AddGamesForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :games, :teams, column: :home_team_id
  end
end
