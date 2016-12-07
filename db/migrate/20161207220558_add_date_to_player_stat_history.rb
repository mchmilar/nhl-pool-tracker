class AddDateToPlayerStatHistory < ActiveRecord::Migration
  def change
  	add_column :player_stat_histories, :date, :date, index: true 
  end
end
