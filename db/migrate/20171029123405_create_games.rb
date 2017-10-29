class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :nhl_game_id
      t.string :link
      t.string :game_type
      t.integer :season
      t.datetime :game_date
      t.references :away_team
      t.references :home_team
      t.timestamps null: false
    end
  end
end