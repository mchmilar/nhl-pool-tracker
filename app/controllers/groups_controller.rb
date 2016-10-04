class GroupsController < ApplicationController
  require 'open-uri'
  
  def import
    @response = Group.batch_import('http://www.officepools.com/nhl/classic/186420/data-2016.04.27.20.43.17.970964.js')
    
  end
end
