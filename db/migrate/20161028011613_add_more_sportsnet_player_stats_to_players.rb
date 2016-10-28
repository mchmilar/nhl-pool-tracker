class AddMoreSportsnetPlayerStatsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :goals, :integer
    add_column :players, :assists, :integer
    add_column :players, :points, :integer
    add_column :players, :ppg, :integer
    add_column :players, :ppp, :integer
    add_column :players, :shg, :integer
    add_column :players, :shp, :integer
    add_column :players, :gwg, :integer
    add_column :players, :shots, :integer
    add_column :players, :s_pct, :decimal
    add_column :players, :atoi, :decimal
  end
end
