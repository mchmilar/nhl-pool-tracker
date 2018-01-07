class CreateInjuries < ActiveRecord::Migration
  def change
    create_table :injuries do |t|
      t.integer :player_id
      t.date :injury_date
      t.string :type
      t.string :note

      t.timestamps null: false
    end
  end
end
