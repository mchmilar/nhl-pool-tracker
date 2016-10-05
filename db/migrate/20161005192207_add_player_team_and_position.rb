class AddPlayerTeamAndPosition < ActiveRecord::Migration
  def change
    add_column :players, :team, :string
    add_column :players, :position, :string
  end
end
