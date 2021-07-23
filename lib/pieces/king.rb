# frozen_string_literal: true

class King
  POS_MVS = [[1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]].freeze
  attr_accessor :color, :symbol, :moved

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2654", "\u265A"]
    @moved
  end

  def possible_moves(position, grid, result = [])
    POS_MVS.each do |move|
      new_move = [position[0] + move[0], position[1] + move[1]]

      next unless new_move[0].between?(0, 7) && new_move[1].between?(0, 7)
      slot = grid[new_move[0]][new_move[1]]
      result << new_move if slot.piece.nil? || slot.piece.color != @color
    end

    result
  end
end
