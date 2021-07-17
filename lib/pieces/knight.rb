# frozen_string_literal: true

class Knight
  POS_MVS = [[-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2]].freeze
  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2658", "\u265E"]
  end

  def possible_moves(position, grid, moves = [])
    POS_MVS.each do |possible_move|
      x = position[0] + possible_move[0]
      y = position[1] + possible_move[1]

      move = [x, y]
      # puts "Rejected [#{x}, #{y}]" unless x.between?(0, 7) && y.between?(0, 7)
      moves << move if x.between?(0, 7) && y.between?(0, 7) && valid_knight_move(move, grid)
    end
    moves
  end

  def valid_knight_move(move, grid)
    grid[move[0]][move[1]].piece.nil? || grid[move[0]][move[1]].piece.color != @color
  end
end
