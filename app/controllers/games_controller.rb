class GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    if session[:token].nil?
      session[:token] = SecureRandom.urlsafe_base64(16)
      @s_id = session[:token]
      @game = ChessGame.new_game
      @dbgame = create_game(@game, @s_id)
      flash[:notice] = 'New Session'
      render :index
    else
      if current_game
        @dbgame = current_game
        @game = @dbgame.from_s
        @s_id = session[:token]
        render :index
      else
        session[:token] = SecureRandom.urlsafe_base64(16)
        @s_id = session[:token] 
        @game = new_game_data
        @dbgame = create_game(@game, @s_id)
        flash[:notice] = 'Welcome Back'
        render :index 
      end     
    end
  end
  
  def newgame
    current_game.update_attributes({session_id: 'abandoned'})
    session[:token] = nil
    redirect_to root_url
  end
  
  def move
    @dbgame = current_game
    @game = @dbgame.from_s
    start = start_params
    land = end_params
    notice = @game.process_move(start,land)
    flash[:notice] = notice
    @s_id = session[:token]
    update_state(@dbgame, @game, @s_id)
    render :index
  end
  
  private
  
  def create_game(chessgame, s_id)
    game = Game.create({
      state: chessgame.to_s,
      turn: chessgame.turn,
      session_id: s_id
    })
    @current_game = game
    game
  end
  
  def update_state(dbgame, chessgame, s_id)
    dbgame.update_attributes({
      state: chessgame.to_s, 
      turn: chessgame.turn,
      session_id: s_id
    })
    @current_game = dbgame
  end
  
  def current_game
    c_g = @current_game || Game.find_by_session_id(session[:token])
  end
  
  def new_game_data
    ChessGame.new_game
  end
  
  def start_params
    [params[:start][0].to_i, params[:start][2].to_i]
  end
  
  def end_params
    [params[:landing][0].to_i, params[:landing][2].to_i]
  end
  
  
end
