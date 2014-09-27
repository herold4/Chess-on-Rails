require 'board'
require 'player'

class Game
  
  attr_reader :board, :whites_turn
  
  def initialize(white_player = Player.new, black_player = Player.new)
    @white_player = white_player
    @black_player = black_player
    @whites_turn = true
    @board = Board.new
  end
  
  def won?
    if @whites_turn
      @board.checkmate?(:white)
    else
      @board.checkmate?(:black)
    end
    
  end
  
  def winner
    if won?
      if @whites_turn
        :black
      else
        :white
      end
    else
      nil
    end
  end
  
  def play
    while true
      if @whites_turn
        turn = :white
      else
        turn = :black
      end
      if @whites_turn
        @white_player.move(@board, :white)
      else
        @black_player.move(@board, :black)
      end
      check_pawn_promotion(turn)
      @whites_turn = !@whites_turn
    end
  end
  
  def check_pawn_promotion(color)
    class_hash = {"queen" => Queen, "rook" => Rook, "bishop" => Bishop, "knight" => Knight}
    
    pawns = @board.get_pieces(color).select { |piece| piece.is_a?(Pawn) }
    pawns.each do |pawn|
      if (color == :white && pawn.y == 0) || (color == :black && pawn.y == 7)

        new_piece = gets.chomp.downcase
        if !class_hash[new_piece]
          raise 'Thats not a valid promotion'
        end
        @board[pawn.x, pawn.y] = class_hash[new_piece].new(pawn.color, @board, pawn.x, pawn.y)
      end
    end 
  end

end