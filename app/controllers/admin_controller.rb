class AdminController < ApplicationController
  def panel
  end

  def update_player_stats
  	flash[:updated_stats] = Player.update_stats
    redirect_to players_path
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
end
