class GroupsController < ApplicationController
  require 'open-uri'
  
  def index
    @groups = Group.sorted_hash
  end

  def import

  end
  
  def do_import
    failed_adds = Group.batch_import(params[:group][:import_url])
    message = ""
    failed_adds.each { |fail| "#{message}\n#{fail}" }
    flash[:danger] = message
    redirect_to groups_path
  end
end
