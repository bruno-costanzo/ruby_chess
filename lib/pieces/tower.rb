# frozen_string_literal: true

class Tower
  PATH_MVS = [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze

  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2656", "\u265C"]
    @moved = false
  end

  def possible_moves(position, grid, moves = [])
    PATH_MVS.each do |path|
      moves << tower_path_finder(position, grid, path)
    end

    moves.filter! { |move| !move.empty? }

    moves.flatten(1)
  end

  def tower_path_finder(position, grid, step, result = [])
    move = [position[0] + step[0], position[1] + step[1]]

    return result unless move[0].between?(0, 7) && move[1].between?(0, 7)

    slot = grid[move[0]][move[1]]

    if slot.piece.nil?
      result << move
      tower_path_finder(move, grid, step, result)
    elsif slot.piece.color == @color
      result
    elsif slot.piece.color != @color
      result << move
      result
    end
  end
end
