class PlayersController < ApplicationController
  def index
    @players = Player.all.sort_by { |key, value| value }
  end
  
  def import
    Player.import(params[:file])
    redirect_to root_url, notice: "Players imported"
  end
end