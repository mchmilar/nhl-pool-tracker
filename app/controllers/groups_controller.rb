class GroupsController < ApplicationController
  require 'open-uri'
  require 'pry'
  def index
    @groups = Group.sorted_array
    @schedule = Team.getActiveTonight
    binding.pry
    @playing_tonight = Hash.new{ |hash, key| hash[key] = 0 }
    @groups.each do |group|
      group.players.each do |player|
        if @schedule[player.team_abbrev]
          @playing_tonight[group.name] += 1
        end
      end
    end
  end
end
