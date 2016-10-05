class GroupsController < ApplicationController
  require 'open-uri'
  
  def index
    @groups = Group.hash
  end
  
  def import
    failed_adds = Group.batch_import('http://www.officepools.com/nhl/classic/214525/data-2016.10.05.14.23.30.307415.js')
    message = ""
    failed_adds.each { |fail| "#{message}\n#{fail}" }
    flash[:danger] = message
    redirect_to groups_path
  end
end
