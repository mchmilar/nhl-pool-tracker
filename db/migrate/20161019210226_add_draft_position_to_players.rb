class AddDraftPositionToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :draft_pos, :integer
  end
end
