# frozen_string_literal: true

class Tower
  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2656", "\u265C"]
  end
end
