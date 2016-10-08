class ChangeTeamDataTypeInPlayers < ActiveRecord::Migration
  def change
    rename_column :players, :team, :team_id
    change_column :players, :team_id, :integer
  end
end
