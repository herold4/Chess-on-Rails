# encoding: utf-8
require 'board'

class Game < ActiveRecord::Base
  validates :state, presence: true
  validates :turn, presence: true
  validates :session_id, presence: true
  
  def from_s
    g = ChessGame.blank
    if self.turn == 'white'
      g.whites_turn = true
    else 
      g.whites_turn = false
    end
    piece_hash = {
      "♚" => [King, 'black'],
      "♛" => [Queen, 'black'],
      "♜" => [Rook, 'black'],
      "♝" => [Bishop, 'black'],
      "♞" => [Knight, 'black'],
      "♟" => [Pawn, 'black'],
      "♔" => [King, 'white'],
      "♕" => [Queen, 'white'],
      "♖" => [Rook, 'white'],
      "♗" => [Bishop, 'white'],
      "♘" => [Knight, 'white'],
      "♙" => [Pawn, 'white'],
      "__" => true      
    }
    str_arr = self.state.split("\n")
    str_arr.each_with_index do |row_str, row|
      row_arr = row_str.split('').select {|c| piece_hash[c]}
      row_arr.each_with_index do |char,col|
        if char == "__"
          g.board[col,row] = nil
        else
          clazz = piece_hash[char][0]
          color = piece_hash[char][1].to_sym
          p = clazz.new(color,g.board,col,row)
          g.board[col,row] = p
        end
      end
    end
    return g
  end
  
  def self.make_game_string
    g = ChessGame.new
    g.to_s    
  end
end

class ChessGame
  
  attr_accessor :board, :whites_turn
  
  def initialize
    @whites_turn = true
  end
  
  def self.new_game
    game = ChessGame.new
    game.board = Board.new
    game.board.place_pieces
    game
  end
  
  def self.blank
    game = ChessGame.new
    game.board = Board.new
    game
  end
  
  def process_move(s_pos, e_pos)
    c_color = (@whites_turn ? :white : :black)
    res = @board.move(s_pos, e_pos, c_color)
    check_pawn_promotion
    @whites_turn = !@whites_turn if res == 'executed'
    next_color = (@whites_turn ? :white : :black)
    if res =='executed' && @board.in_check?(next_color)
      res = "Player In Check!!" 
      res = "THAT LOOKS LIKE CHECKMATE!" if won?
    end
    return res
  end
  
  def won?
    if @whites_turn
      @board.checkmate?(:white)
    else
      @board.checkmate?(:black)
    end
  end
  
  def check_pawn_promotion
    color = (@whites_turn ? :white : :black)
    pawns = @board.get_pieces(color).select { |piece| piece.is_a?(Pawn) }
    pawns.each do |pawn|
      if (color == :white && pawn.y == 0) || (color == :black && pawn.y == 7)
        @board[pawn.x, pawn.y] = Queen.new(pawn.color, @board, pawn.x, pawn.y)
      end
    end 
  end
  
  
  def to_s
    @board.to_s
  end
  
  def turn
    @whites_turn ? 'white' : 'black'
  end

end