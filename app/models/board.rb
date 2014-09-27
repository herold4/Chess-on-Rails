# encoding: utf-8
require 'colorize'
require 'piece'

class Board
  attr_accessor :grid
  
  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
    
    # pawns
    (0...8).each do |col|
      grid[1][col] = Pawn.new(:black, self, col, 1)
      grid[6][col] = Pawn.new(:white, self, col, 6)
    end
    # kings
    grid[7][4] = King.new(:white, self, 4, 7)
    grid[0][4] = King.new(:black, self, 4, 0)
    # queens
    grid[7][3] = Queen.new(:white, self, 3, 7)
    grid[0][3] = Queen.new(:black, self, 3, 0)
    # rooks
    grid[0][0] = Rook.new(:black, self, 0, 0)
    grid[0][7] = Rook.new(:black, self, 7, 0)
    grid[7][0] = Rook.new(:white, self, 0, 7)
    grid[7][7] = Rook.new(:white, self, 7, 7)
    # knights
    grid[0][1] = Knight.new(:black, self, 1, 0)
    grid[0][6] = Knight.new(:black, self, 6, 0)
    grid[7][1] = Knight.new(:white, self, 1, 7)
    grid[7][6] = Knight.new(:white, self, 6, 7)
    # bishops
    grid[0][2] = Bishop.new(:black, self, 2, 0)
    grid[0][5] = Bishop.new(:black, self, 5, 0)
    grid[7][2] = Bishop.new(:white, self, 2, 7)
    grid[7][5] = Bishop.new(:white, self, 5, 7)
  end

  def []=(x, y, value)
    grid[y][x] = value
  end
  
  def [](x,y)
    grid[y][x]
  end
  
  def get_pieces(color)
    grid.flatten.compact.select { |piece| piece.color == color }
  end
  
  def in_check?(color)
    if color == :white
      black_threats = get_pieces(:black)
      white_king = get_pieces(:white).select { |piece| piece.is_a?(King) }[0]
      white_king_pos = [white_king.x, white_king.y]
      black_threats.each do |piece|
        if piece.moves.include?(white_king_pos)
          return true
        end
      end
    elsif color == :black
      white_threats = get_pieces(:white)
      black_king = get_pieces(:black).select { |piece| piece.is_a?(King) }[0]
      black_king_pos = [black_king.x, black_king.y]
      white_threats.each do |piece|
        if piece.moves.include?(black_king_pos)
          return true
        end
      end
    end
    false
  end


  def deep_dup
    boardcopy = Board.new
    boardcopy.grid = grid.dup
    8.times do |y| 
      boardcopy.grid[y] = boardcopy.grid[y].dup
      8.times do |x|
        next if boardcopy[x, y].nil?
        boardcopy[x, y] = boardcopy[x, y].dup(boardcopy)
      end
    end
    boardcopy
  end
  
  def move(start_pos, end_pos, color)
    piece = self[start_pos[0], start_pos[1]]
    if piece.color != color
      return 'That is Not Your Piece'
    elsif !piece.moves.include?(end_pos)
      return 'Invalid Move'
    else
      dupboard = deep_dup
      dupboard[start_pos[0], start_pos[1]].move(end_pos[0], end_pos[1])
      if dupboard.in_check?(color)
        return 'That Leaves You In Check'
      end
      piece.move(end_pos[0], end_pos[1])
    end
    return 'executed'
  end
  
  def checkmate?(color)
    grid.each do |row|
      row.each do |tile|
        next if tile.nil? || tile.color != color
        tile.moves.each do |potential_move|
          begin
            dupboard = deep_dup
            dupboard.move([tile.x, tile.y], potential_move, color)
          rescue InCheckException
            next
          end
          return false
        end
      end
    end
    true
  end
  
  def to_s
    result = "\n"
    grid.each_with_index do |row, i|
      result << (i + 1).to_s
      row.each_with_index do |piece, i2|
        piece ||= "__"
        result << " #{piece} " if (i + i2) % 2 == 0
        result << " #{piece} " if (i + i2) % 2 == 1
      end
      result << "#{i + 1}\n"
    end
    return result
  end
  

end
