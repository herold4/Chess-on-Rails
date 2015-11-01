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
    res_arr = @board.move(s_pos, e_pos, c_color)
    check_pawn_promotion
    @whites_turn = !@whites_turn if res_arr[1] == 'executed'
    next_color = (@whites_turn ? :white : :black)
    if res_arr[1] == 'executed' && @board.in_check?(next_color)
      res_arr[1] = "Player In Check!!" 
      res_arr[1] = "That looks like CHECKMATE!" if won?
    end
    return res_arr
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