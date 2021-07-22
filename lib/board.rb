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



  def move(position, place, grid = @grid)
    grid[position[0]][position[1]].piece.moved = true if grid[position[0]][position[1]].piece.instance_of?(Pawn)
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

  def get_fake_moves(x, y, color, grid, result = [])
    piece = grid[x][y].piece unless grid[x][y].piece.nil? || grid[x][y].piece.color == color
    moved = piece.moved if piece.instance_of?(Pawn)
    result = piece.possible_moves([x, y], grid)
    piece.moved = moved if piece.instance_of?(Pawn)
    result
  end

  # Player_turn

  def player_turn_started(color)
    possible_moves(color)

  end

  def possible_moves(color, result = [])
    pieces_and_xy = get_all_pieces(color)
    xy_and_moves = get_all_moves(pieces_and_xy)
    xy_and_moves.select do |move|
      king_in_safe?(move, opossite_color(color))
    end
  end

  def king_in_safe?(move, color, fake_board = Board.new(@player_white, @player_black))
    copy_original_board(fake_board)
    fake_board.fake_move(move[0], move[1])
    !fake_board.check?(color)
  end

  def check?(color, king_pos = king_position(color), moves = [])
    moves = self_check_moves(color)
    moves.each do |move|
      return true if move[1] == king_pos
    end
    false
  end

  def checkmate?(color, moves)
    moves.each do |move|
      return false if king_in_safe?(move, color)
    end

    true
  end

  def self_check_moves(color, result = [])
    pieces_and_xy = get_all_pieces(color)
    get_all_moves(pieces_and_xy)
  end

  def copy_original_board(fake_board)
    fake_board.grid.each_with_index do |row, idx_row|
      row.each_with_index do |slot, idx_column|
        fake_board.grid[idx_row][idx_column] = grid[idx_row][idx_column].clone
      end
    end
  end

  def fake_move(position, place_to_move, moved = nil)
    piece = grid[position[0]][position[1]].piece
    moved = piece.moved if piece.instance_of?(Pawn)
    move(position, place_to_move, grid)
    piece.moved = moved if piece.instance_of?(Pawn)
  end

  def opossite_color(color)
    color == 'white' ? 'black' : 'white'
  end

  def get_all_moves(pieces_and_xy, result = [])
    pieces_and_xy.each do |piece_and_xy|
      piece_and_xy[0].possible_moves(piece_and_xy[1], grid).each do |pos_move|
        result << [piece_and_xy[1], pos_move]
      end
    end
    result
  end

  def get_all_pieces(color, pieces_and_pos = [])
    grid.each_with_index do |row, x|
      row.each_with_index do |slot, y|
        pieces_and_pos << [slot.piece, [x, y]] unless slot.piece.nil? || slot.piece.color == color
      end
    end

    pieces_and_pos
  end

  def get_piece_to_move(piece = nil)
    piece = gets.chomp.downcase until valid_piece_to_move?(piece)

    puts display_valid_piece(piece)
    piece
  end

  def get_piece_moves(piece, moves, result = [])
    moves.each do |move|
      result << move[1] if move[0] == piece
    end

    result
  end
end
