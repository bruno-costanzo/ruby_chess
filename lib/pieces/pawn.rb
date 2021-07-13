# frozen_string_literal: true

class Pawn
  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2659", "\u265F"]
  end
end