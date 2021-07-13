# frozen_string_literal: true

require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/knight'
require_relative './pieces/pawn'
require_relative './pieces/tower'
require_relative './pieces/queen'
require_relative 'display'

class Board
  POSITIONS_ZERO = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], [7, 0], [7, 7], [7, 1], [7, 6], [7, 2], [7, 5], [7, 3], [7, 4], [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [0, 0], [0, 7], [0, 1], [0, 6], [0, 2], [0, 5], [0, 3], [0, 4]]


  include Display
  Slot = Struct.new(:color, :piece)
  attr_accessor :grid

  def initialize(grid = Array.new(8) { Array.new(8) { Slot.new } }, pieces_positions = nil)
    @grid = grid
    @pieces_position = pieces_positions
  end

  def paint_board
    color = 'black'
    @grid.each do |row|
      color = (color == 'black' ? 'white' : 'black')
      row.each do |slot|
        slot.color = color
        color = (color == 'black' ? 'white' : 'black')
      end
    end
  end

  def set_up_new_board
    paint_board
    order_pieces
    display_board(@grid)
  end

  def order_pieces
    paint_board
    total_pieces = half_pieces('white') + half_pieces('black')
    total_pieces.each do |piece_with_position|
      @grid[piece_with_position[1][0]][piece_with_position[1][1]].piece = piece_with_position[0]
    end
  end

  def half_pieces(color, result = [], arr_of_positions = POSITIONS_ZERO)
    positions = color == 'white' ? arr_of_positions[0..16] : arr_of_positions[16..31]
    8.times { result << [pawn(color), positions.shift] }
    2.times { result << [tower(color), positions.shift] }
    2.times { result << [knight(color), positions.shift] }
    2.times { result << [bishop(color), positions.shift] }
    result << [queen(color), positions.shift]
    result << [king(color), positions.shift]
    result
  end

  def pawn(color)
    Pawn.new(color)
  end

  def tower(color)
    Tower.new(color)
  end

  def bishop(color)
    Bishop.new(color)
  end

  def knight(color)
    Knight.new(color)
  end

  def queen(color)
    Queen.new(color)
  end

  def king(color)
    King.new(color)
  end
end
