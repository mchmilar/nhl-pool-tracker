class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :gp
      t.integer :w
      t.integer :l
      t.integer :ot
      t.integer :p
      t.integer :row
      t.decimal :p_pct
      t.integer :gf
      t.integer :ga
      t.decimal :pp_pct
      t.decimal :pk_pct
      t.decimal :shots_for_gp
      t.decimal :shots_against_gp
      t.decimal :fow_pct
    	t.datetime :created_at
  	  t.datetime :updated_at
    end
  end
end
