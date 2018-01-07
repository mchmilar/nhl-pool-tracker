class AddNhlIdToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :nhl_id, :integer
  end
end
