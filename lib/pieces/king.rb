# frozen_string_literal: true

class King
  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2654", "\u265A"]
  end
end
