class PlayersController < ApplicationController
  def index
    @players = Player.all.sort_by { |hsh| hsh[:lwl_rank] }
  end
  
  def import
    Player.import(params[:file])
    redirect_to root_url, notice: "Players imported"
  end
end