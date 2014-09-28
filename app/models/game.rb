require 'board'

class Game
  
  attr_reader :board, :whites_turn
  
  def initialize
    @whites_turn = true
    @board = Board.new
  end
  
  def self.new_game
    @@game = Game.new
  end
  
  def process_move(s_pos, e_pos)
    c_color = (@whites_turn ? :white : :black)
    res = @board.move(s_pos, e_pos, c_color)
    @whites_turn = !@whites_turn if res == 'executed'
    c_color = (@whites_turn ? :white : :black)
    if res =='executed' && @board.in_check?(c_color)
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
  
  def self.global_game
    @@game ||= Game.new
  end

end