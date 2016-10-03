class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      
      t.string :name
      t.integer :lwl_rank
      t.integer :lwl_pts
      t.integer :pts
      t.integer :gp
    	t.datetime :created_at
  	  t.datetime :updated_at
    end
  end
end
