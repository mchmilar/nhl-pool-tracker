class AddIndexAndDateToPlayerStatHistories < ActiveRecord::Migration
  def change
  	add_index :player_stat_histories, :player_id
  end
end
