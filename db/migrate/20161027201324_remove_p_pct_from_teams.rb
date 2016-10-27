class RemovePPctFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :p_pct
  end
end
