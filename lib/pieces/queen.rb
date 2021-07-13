# frozen_string_literal: true

class Queen
  attr_accessor :color, :symbol


  def initialize(color = nil)
    @color = color
    @symbol = ["\u2655", "\u265B"]
  end
end
