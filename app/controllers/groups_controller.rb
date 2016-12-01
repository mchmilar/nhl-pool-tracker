class GroupsController < ApplicationController
  require 'open-uri'
  
  def index
    @groups = Group.sorted_array
  end
end
