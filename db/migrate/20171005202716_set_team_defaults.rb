class SetTeamDefaults < ActiveRecord::Migration
  def change
    change_column_default :teams, :pkPctg, to: 0
  end
end
