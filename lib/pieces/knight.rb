# frozen_string_literal: true

class Knight
  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2658", "\u265E"]
  end
end
