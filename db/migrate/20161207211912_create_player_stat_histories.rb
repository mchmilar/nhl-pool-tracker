class CreatePlayerStatHistories < ActiveRecord::Migration
  def change
    create_table :player_stat_histories do |t|
      t.integer :player_id
      t.integer :team_id
      t.integer :pts
      t.integer :gp
      t.integer :goals
      t.integer :assists
      t.integer :ppg
      t.integer :shg
      t.integer :shp
      t.integer :shots
      t.decimal :s_pct
      t.decimal :atoi
      

      t.timestamps null: false
    end
  end
end
