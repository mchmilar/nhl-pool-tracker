class GroupsController < ApplicationController
  require 'open-uri'
  
  def index
    @groups = Group.sorted_hash
  end
end
