class PlayersController < ApplicationController
  def index
    @players = Player.all
  end
  
  def import
    Player.import(params[:file])
    redirect_to root_url, notice: "Players imported"
  end
end