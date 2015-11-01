# encoding: utf-8

class Game < ActiveRecord::Base
  validates :state, presence: true
  validates :turn, presence: true
  validates :session_id, presence: true
  
  has_many :players
  
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
      "_" => true      
    }
    str_arr = self.state.split("\n")
    str_arr.each_with_index do |row_str, row|
      row_arr = row_str.split('').select {|c| piece_hash[c]}
      row_arr.each_with_index do |char,col|
        if char == "_"
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