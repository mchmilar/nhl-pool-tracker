class AdminController < ApplicationController
  before_action :logged_in_user

  def panel
  end

  def update_player_stats
  	flash[:updated_stats] = Player.update_stats
    respond_to do |format|
      format.html {redirect_to players_path}
    end    
  end

  def import_groups
    failed_adds = Group.batch_import(params[:admin][:import_url])
    message = ""
    failed_adds.each { |fail| "#{message}\n#{fail}" }
    flash[:danger] = message
    redirect_to groups_path
  end

  def update_teams
    if Team.update_teams
      flash.now[:success] = "Successfully updated teams!"
    else
      flash.now[:danger] = "Error updating teams."
    end
    render 'panel'
  end

  private
  
  # Before filters

  def logged_in_user
    redirect_to login_path, notice: "Please login." unless logged_in?
  end
end
