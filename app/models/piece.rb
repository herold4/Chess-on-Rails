# encoding: utf-8
class Piece
  attr_accessor :x, :y
  attr_reader :color, :board
  
  def initialize(color, board, x, y)
    @color = color
    @board = board
    @x, @y = x, y
  end
  
  def html
    x.to_s + 'x' + y.to_s + 'y'
  end
  
  def valid_move?(x, y)
    (0...8).include?(x) && (0...8).include?(y)
  end
  
  def to_s
    black_hash = {king: "♚",queen: "♛", rook: "♜", bishop: "♝", knight: "♞", pawn: "♟"}
    white_hash = {king: "♔",queen: "♕", rook: "♖", bishop: "♗", knight: "♘", pawn: "♙"}
    
    if color == :black
      black_hash[self.class.to_s.downcase.to_sym]
    elsif color == :white
      white_hash[self.class.to_s.downcase.to_sym]
    end
  end
  
  def move(new_x, new_y)
    capture = board[x,y]
    board[x, y] = nil
    @x, @y = new_x, new_y
    board[new_x, new_y] = self
    if capture
      return [capture.class,capture.color]
    else
      return [nil,nil]
    end
  end

  
  def moves
    raise NoMethodError.new "Called Piece SuperClass 'moves' method"
  end
  
  def dup(boardcopy)
    result = self.class.new(color, boardcopy, x, y)
    if @moved
      result.moved = @moved
    end
    result
  end
  

end


class SteppingPiece < Piece
  
  def moves(deltas)
    
    results = []
    deltas.each do |delt|
      newx, newy = [x + delt[0], y + delt[1]]
      next unless valid_move?(newx, newy)
      destination_sq = board[newx, newy]
      occupied = destination_sq && destination_sq.color == self.color
      
      results << [newx, newy] unless occupied
      
    end
    results
    
  end
end

class SlidingPiece < Piece
  
    
  
  def moves(orthogonal = false, diagonal = false)
    results = []
    deltas = []
    if orthogonal
      deltas += [
        [ 0,  1],
        [ 0, -1],
        [ 1,  0],
        [-1,  0]
      ]
    end
    if diagonal
      deltas += [
        [ 1, -1], 
        [ 1,  1], 
        [-1, -1], 
        [-1,  1]
      ]
    end
   
    deltas.each do |movement|
      limit = [x + movement[0], y + movement[1]]
      while (0...8).include?(limit[0]) && (0...8).include?(limit[1])
        destination_sq = board[limit[0], limit[1]]
        if destination_sq
          if destination_sq.color != self.color
            capture_square = [limit[0], limit[1]]
            results << capture_square
          end
          break
        else
          results << [limit[0], limit[1]]
          limit[0] += movement[0]
          limit[1] += movement[1]
        end
      end
    end
  
    results
end
  
end

class Pawn < Piece
  attr_accessor :moved
  
  def initialize(color, board, x, y)
    @moved = false
    super
  end
  
  def moves
    results =[]
    directions = {black: 1, white: -1}
    starting_y = {black: 1, white: 6}
    vertical_movement = directions[color]
    if board[x, y + vertical_movement].nil?
      results << [x, y + vertical_movement]
      if y == starting_y[color] && board[x, y + (vertical_movement * 2)].nil?
        results << [x, y + (vertical_movement * 2)]
      end
    end
    [1 , -1].each do |side|
      if valid_move?(x + side, y + vertical_movement)
        square = board[x + side, y + vertical_movement] 
        if square && square.color != color
          results << [x + side, y + vertical_movement]
        end
      end
    end
    results
  end
  
  def move(new_x, new_y)
    super
    @moved = true
  end
end

class Knight < SteppingPiece
  
  def moves
    deltas = [
      [-2, -1],
      [-2,  1],
      [-1, -2],
      [-1,  2],
      [ 1, -2],
      [ 1,  2],
      [ 2, -1],
      [ 2,  1]
    ]
    super(deltas)
  end
end

class Rook < SlidingPiece
  attr_accessor :moved
  
  def initialize(color, board, x, y)
    @moved = false
    super
  end
  
  def moves
    super(true, false) #true for orthogonal, false for diagonal 
  end
  
  def move(new_x, new_y)
    super
    @moved = true
  end
end

class Bishop < SlidingPiece
  def moves
    super(false, true)
  end 
end

class Queen < SlidingPiece
  def moves
    super(true, true) #true for orthogonal, true for diagonal 
  end
end

class King < SteppingPiece
  
  attr_accessor :moved
  
  def initialize(color, board, x, y)
    @moved = false
    super
  end
  
  def move(new_x, new_y)
    if new_x - x == 2
      rook = board[7, y]
      rook.move(5, y)
    elsif new_x - x == -2
      rook = board[0, y]
      rook.move(3, y)
    end
    super
    @moved = true
  end
  
  def moves
    deltas = (-1..1).to_a.product((-1..1).to_a).reject {|pair| pair == [0, 0]}
    result = super(deltas)
    
    rooks = board.get_pieces(color).select { |piece| piece.is_a?(Rook) }
    rooks.each do |rook|
      if castle?(rook)
        if rook.x == 0
          result << [2, self.y]
        elsif rook.x == 7
          result << [6, self.y]
        end
      end
    end
     
    
    result
  end
  
  def castle?(rook)
    if moved || rook.moved
      return false
    end
    if rook.x == 0 #left rook
      (1..3).each do |xcoord| #checking if path is clear
        return false if board[xcoord, rook.y]
      end
      
    end
    if rook.x == 7
      (5..6).each do |xcoord|
        return false if board[xcoord, rook.y]
      end
      
    end
    true
  end
  
end
