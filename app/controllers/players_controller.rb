class PlayersController < ApplicationController

  def index
    @players = Player.order('pts IS NULL, pts DESC')
    logger.debug "In Players#index"
  end

  def import
    Player.import(params[:file])
    redirect_to players_path, notice: "Players imported"
  end

  def new

  end

  def show
    @player = Player.find(params[:id])
    @player_class = @player.draft_class
  end

  def create
    @player = Player.new(player_params)
  end
  
  private

  def player_params
    params.require(:player).permit(:name, :team_id)
  end
end
