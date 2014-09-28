class GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    if session[:session_id].nil?
      session[:session_id] = SecureRandom.urlsafe_base64(16)
      @game = ChessGame.new_game
      @dbgame = Game.new
      @dbgame.state = @game.to_s
      @dbgame.turn = @game.turn
      @dbgame.session_id = session[:session_id]
      flash[:notice] = "Database Error" unless @dbgame.save!
      render :index
    else 
      @dbgame = Game.find_by_session_id(session[:session_id]) || new_game_data
      @game = @dbgame.from_s
      render :index      
    end
  end
  
  def move
    @dbgame = Game.find_by_session_id(session[:session_id]) || new_game_data
    @game = @dbgame.from_s
    start = start_pos
    land = end_pos
    notice = @game.process_move(start,land)
    @dbgame.state = @game.to_s
    @dbgame.turn = @game.turn
    @dbgame.session_id = session[:session_id]
    flash[:notice] = notice
    render :index
  end
  
  def newgame
    session[:session_id] = nil
    redirect_to root_url
  end
  
  
  private
  
  def new_game_data
    dbgame = Game.new
    game = ChessGame.new
    dbgame.state = game.to_s
    dbgame.turn = game.turn
    dbgame
  end
  
  def start_pos
    [params[:start][0].to_i, params[:start][2].to_i]
  end
  
  def end_pos
    [params[:landing][0].to_i, params[:landing][2].to_i]
  end
  
  
end
