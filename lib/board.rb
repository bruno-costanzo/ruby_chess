# frozen_string_literal: true

require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/knight'
require_relative './pieces/pawn'
require_relative './pieces/tower'
require_relative './pieces/queen'
require_relative 'display'

class Board
  POSITIONS_ZERO = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], [7, 0], [7, 7], [7, 1], [7, 6], [7, 2], [7, 5], [7, 3], [7, 4], [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [0, 0], [0, 7], [0, 1], [0, 6], [0, 2], [0, 5], [0, 3], [0, 4]].freeze


  include Display
  Slot = Struct.new(:color, :piece)
  attr_accessor :grid, :death_pieces, :white_king, :black_king

  def initialize(player_one, player_two, grid = Array.new(8) { Array.new(8) { Slot.new } })
    @grid = grid
    @white_king = nil
    @black_king = nil
    @player_white = player_one
    @player_black = player_two
    @death_pieces = []
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

  def get_pos_moves(position)
    piece_position = parse_position(position)
    possible_moves = @grid[piece_position[0]][piece_position[1]].piece.possible_moves(piece_position, @grid)
    possible_moves.map { |move| inversed_parse(move) }
  end

  def inversed_parse(position)
    column_letters = ('a'..'h').to_a
    row_numbers = ('1'..'8').to_a.reverse

    "#{column_letters[position[1]]}#{row_numbers[position[0]]}"
  end

  def move(piece_position, place_to_go, grid = @grid)
    position = parse_position(piece_position)
    grid[position[0]][position[1]].piece.moved = true if grid[position[0]][position[1]].piece.instance_of?(Pawn)
    place = parse_position(place_to_go)
    @death_pieces << grid[place[0]][place[1]].piece unless grid[place[0]][place[1]].piece.nil?
    grid[place[0]][place[1]].piece = grid[position[0]][position[1]].piece
    grid[position[0]][position[1]].piece = nil
  end

  def king_position(color, king_pos = nil)
    @grid.each_with_index do |row, x|
      row.each_with_index do |slot, y|
        king_pos = [x, y] if slot&.piece.instance_of?(King) && slot.piece.color == color
      end
    end
    king_pos
  end

  def check?(fake_board, king_pos, color, moves = [])
    fake_board.grid.each_with_index do |row, x|
      row.each_with_index do |slot, y|
        moves = fake_board.get_fake_moves(x, y, color, fake_board.grid) unless slot.piece.nil? || slot.piece.color == color

        return true if moves.include?(king_pos)
      end
    end
    false
  end

  def get_fake_moves(x, y, color, grid, result = [])
    piece = grid[x][y].piece unless grid[x][y].piece.nil? || grid[x][y].piece.color == color
    moved = piece.moved if piece.instance_of?(Pawn)
    result = piece.possible_moves([x, y], grid)
    piece.moved = moved if piece.instance_of?(Pawn)
    result
  end
end
