class AddPppToPlayerStatHistory < ActiveRecord::Migration
  def change
  	add_column :player_stat_histories, :ppp, :integer
  end
end
