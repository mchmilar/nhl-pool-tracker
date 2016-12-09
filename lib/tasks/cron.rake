task :cron => :environment do
	puts "Updating Team Stats"
  Team.update_teams

  puts "Updating Player Stats"
  Player.update_stats

  puts "Taking PlayerStatHistory snapshot"
  Player.batch_snapshot

  puts "Done!"
end