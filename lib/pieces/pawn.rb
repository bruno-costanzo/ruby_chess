# frozen_string_literal: true

class Pawn
  POS_MVS = [[-1, 0]].freeze
  POS_FIRST_MVS = [[-1, 0], [-2, 0]].freeze
  POS_ATTACK_MVS = [[-1, -1], [-1, 1]].freeze

  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2659", "\u265F"]
    @moved = false
  end


  def possible_moves(position, grid, result = [])
    unless @moved
      POS_FIRST_MVS.each do | move |
        result << [position[0] + move[0], position[1] + move[1]]
      end
    elsif
    end
  end
end