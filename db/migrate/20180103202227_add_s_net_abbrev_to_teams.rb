class AddSNetAbbrevToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :snet_abbrev, :string
  end
end
