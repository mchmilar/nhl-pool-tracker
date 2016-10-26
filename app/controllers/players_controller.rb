class PlayersController < ApplicationController
  
  def index
    @players = Player.order('pts IS NULL, pts DESC')
    logger.debug "In Players#index"
  end
  
  def import
    Player.import(params[:file])
    redirect_to root_url, notice: "Players imported"
  end

  def update_stats

  end

  def do_update_stats
    flash[:notice] = Player.update_stats
    redirect_to players_path
  end
end