class AddGroupIdToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :group_id, :integer
  end
end
