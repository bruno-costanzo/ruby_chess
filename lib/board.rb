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

  def initialize(player_one, player_two, grid = Array.new(8) { Array.new(8) { Slot.new } }, pieces_positions = nil)
    @grid = grid
    @pieces_position = pieces_positions
    @white_pieces = nil
    @black_pieces = nil
    @player_white = player_one
    @player_black = player_two
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

  # Set up new game methods

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
    @white_pieces = result if color == 'white'
    @black_pieces = result if color == 'black'
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

  # valid_piece?

  def valid_piece_selected?(piece, color)
    position = parse_position(piece)
    piece_there?(position) && valid_piece_color?(position, color)
  end

  def parse_position(piece)
    column_letters = ('a'..'h').to_a
    row_numbers = ('1'..'8').to_a.reverse
    column = column_letters.index(piece.split('')[0])
    row = row_numbers.index(piece.split('')[1])

    [row, column]
  end

  def piece_there?(position)
    slot = grid[position[0]][position[1]]
    return true unless slot.piece.nil?

    puts display_no_piece_there
    false
  end

  def valid_piece_color?(position, color)
    slot = grid[position[0]][position[1]]

    return true if slot.piece.color == color

    puts display_not_player_piece
    false
  end
end
