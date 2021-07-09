# frozen_string_literal: true

class Board
  attr_accessor :data

  def initialize(data = Array.new(8) { Array.new(8) }, params = {})
    @data = data
    @active_piece = params[:active_piece]
    @previous_piece = params[:previous_piece]
    @black_king = params[:black_king]
    @white_king = params[:white_king]
  end
end
