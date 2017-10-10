class AddPlayerTeamAndPosition < ActiveRecord::Migration
  def change
    add_column :players, :team_id, :integer
    add_column :players, :position, :string
  end
end
