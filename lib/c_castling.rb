# frozen_string_literal: true


module Castling

  def valid_castling(king, tower, king_pos, tower_pos)
    if !king.moved && !tower.moved && !pieces_between && !check && row_no_attacked(row_between_maker(king_x, lower, higher))
      (king[1] - tower[1]).positive ? short_castling : long_castling
    else
      puts 'invalid castling'
    end
  end

  def pieces_between
    slots_between = king_y > tower_y ? row_between_maker(king_x, tower_y, king_y) : row_between_maker(king_x, king_y, tower_y)
    slots_between.each { |slot| return true unless slot.piece.nil? }

    false
  end

  def row_between_maker(king_x, lower, higher, result = [])
    (higher - lower).times do |index|
      result << @grid[king_x][lower + index] unless slot.piece.instance_of?(King, Tower)
    end
  end

  def row_no_attacked(row_of_pieces)
    row_of_pieces.each do |piece|
      return false if under_attack?(piece)
    end

    true
  end

  def under_attack?(piece)
    enemy_moves = get_all_moves(enemy_pieces)
    enemy_moves.each { |move| return true if move[1] == piece }

    false
  end
end