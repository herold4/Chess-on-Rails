class GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @game = Game.global_game
    render :index
  end
  
  def move
    @game = Game.global_game
    start = start_pos
    land = end_pos
    notice = @game.process_move(start,land)
    flash[:notice] = notice
    redirect_to root_url
  end
  
  def newgame
    @game = Game.new_game
    render :index
  end
  
  
  private
  
  def start_pos
    [params[:start][0].to_i, params[:start][2].to_i]
  end
  
  def end_pos
    [params[:landing][0].to_i, params[:landing][2].to_i]
  end
  
  
end
