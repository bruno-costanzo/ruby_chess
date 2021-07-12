#frozen_string_literal: true

class Bishop
  attr_accessor :color, :symbol

  def initialize(color = nil)
    @color = color
    @symbol = nil
  end
end
