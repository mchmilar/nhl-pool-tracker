class AddDefaultsToPlayers < ActiveRecord::Migration
  def change
  	change_column_default :players, :lwl_rank, 999
  	change_column_default :players, :lwl_pts, 0
  	change_column_default :players, :pts, 0
  	change_column_default :players, :gp, 0
  	change_column_default :players, :goals, 0
  	change_column_default :players, :assists, 0
  	change_column_default :players, :points, 0
  	change_column_default :players, :ppg, 0
  	change_column_default :players, :ppp, 0
  	change_column_default :players, :shg, 0
  	change_column_default :players, :shp, 0
  	change_column_default :players, :gwg, 0
  	change_column_default :players, :shots, 0
  	change_column_default :players, :s_pct, 0.0
  	change_column_default :players, :atoi, 0.0
  end
end
