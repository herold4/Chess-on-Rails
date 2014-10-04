class GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    if session[:token].nil?
      session[:token] = SecureRandom.urlsafe_base64(16)
      @s_token = session[:token]
      @game = ChessGame.new_game
      create_game(@game, @s_token)
      @white_player = current_game.players.where(white: true).first
      @black_player = current_game.players.where(white: false).first
      flash[:notice] = 'New Session'
      render :index
    else
      if current_game
        @game = current_game.from_s
        @white_player = current_game.players.where(white: true).first
        @black_player = current_game.players.where(white: false).first
        @s_token = session[:token]
        flash[:notice] = 'Welcome Back'
        render :index
      else #if current game not found
        session[:token] = SecureRandom.urlsafe_base64(16)
        @s_token = session[:token] 
        @game = new_game_data
        create_game(@game, @s_token)
        @white_player = current_game.players.where(white: true).first
        @black_player = current_game.players.where(white: false).first
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
    @game = current_game.from_s
    @white_player = current_game.players.where(white: true).first
    @black_player = current_game.players.where(white: false).first
    start = start_params
    land = end_params
    response_arr = @game.process_move(start,land)
    flash[:notice] = response_arr[2]
    @s_token = session[:token]
    if response_arr[0] 
      update_state(@game, @s_token, @white_player, @black_player)
    else
      
    end
    
    render :index
  end
  
  private
  
  def create_game(chessgame, token)
    dbgame = Game.create({
      state: chessgame.to_s,
      turn: chessgame.turn,
      session_id: token
    })
    Player.create({
      white: true,
      game_id: dbgame.id,
      captured: ''
    })
    Player.create({
      white: false,
      game_id: dbgame.id,
      captured: ''
    })
    @current_game = dbgame
  end
  
  def update_state(chessgame, token, white_p = nil, black_p = nil, capt = nil)
    if player && chessgame.turn == 'black'
      white_p.captured += capt
      white_p.save
    elsif player && chessgame.turn == 'white'
      black_p.captured += capt
      black_p.save
    end
    current_game.update_attributes({
      state: chessgame.to_s, 
      turn: chessgame.turn,
      session_id: token
    })
  end
  
  def current_game
    @current_game ||= Game.find_by_session_id(session[:token])
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
