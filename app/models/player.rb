class Player
  def move(board, start, end_pos, color)
      return "You are in check!" if board.in_check?(color)
      board.move(start, end_pos, color)
      return true
  end
end