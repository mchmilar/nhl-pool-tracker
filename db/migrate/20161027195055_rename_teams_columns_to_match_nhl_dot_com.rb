class RenameTeamsColumnsToMatchNhlDotCom < ActiveRecord::Migration
  def change
    rename_column :teams, :gp, :gamesPlayed
    rename_column :teams, :fow_pct, :faceoffWinPctg
    add_column    :teams, :goalsAgainstPerGame, :decimal
    rename_column :teams, :ga, :goalsAgainst
    rename_column :teams, :gf, :goalsFor
    add_column    :teams, :goalsForPerGame, :decimal
    rename_column :teams, :l, :losses
    rename_column :teams, :ot, :otLosses
    rename_column :teams, :pk_pct, :pkPctg
    add_column :teams, :pointPctg, :decimal
    rename_column :teams, :p, :points
    rename_column :teams, :pp_pct, :ppPctg
    rename_column :teams, :row, :regPlusOtWins
    add_column    :teams, :seasonId, :string
    rename_column :teams, :shots_against_gp, :shotsAgainstPerGame
    rename_column :teams, :shots_for_gp, :shotsForPerGame
    rename_column :teams, :team_abbrev, :teamAbbrev
    rename_column :teams, :name, :teamFullName
    add_column    :teams, :ties, :integer
    rename_column :teams, :w, :wins
  end
end
