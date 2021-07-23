# frozen_string_literal: true


module Castling

  def valid_castling(king, tower, king_pos, tower_pos)
    if !king.moved && !tower.moved && !pieces_between(king_pos[0], king_pos[1], tower_pos[1]) && !check?(king.color) && row_no_attacked(king_pos[0], king_pos[1], tower_pos[1], king.color)
      (king_pos[1] - tower_pos[1]).positive? ? long_castling(king_pos[0]) : short_castling(king_pos[0])
    else
      puts 'Invalid castling. Select a piece and move'

      false
    end
  end

  def pieces_between(king_x, king_y, tower_y)
    slots_between = king_y > tower_y ? row_between_maker(king_x, tower_y, king_y) : row_between_maker(king_x, king_y, tower_y)
    slots_between.each { |slot| return true unless slot.piece.nil? }

    false
  end

  def row_between_maker(king_x, king_y, tower_y, result = [])
    higher = king_y > tower_y ? king_y : tower_y
    lower = king_y < tower_y ? king_y : tower_y
    (higher - lower).times do |index|
      slot = @grid[king_x][lower + index]
      result << slot unless slot.piece.instance_of?(King) || slot.piece.instance_of?(Tower)
    end

    result
  end

  def row_no_attacked(king_x, king_y, tower_y, color)
    i = king_y > tower_y ? -1 : 1
    until king_y + i == tower_y
      return false if under_attack?([king_x, king_y + i], color)

      king_y += i
    end

    true
  end

  def under_attack?(slot, color, moves = possible_moves(opossite_color(color)))
    return true if moves.include?(slot)

    false
  end

  def short_castling(row)
    @grid[row][5].piece = @grid[row][7].piece.clone
    @grid[row][7].piece = nil
    @grid[row][6].piece = @grid[row][4].piece.clone
    @grid[row][4].piece = nil

    @grid[row][6].piece.moved = true
    @grid[row][5].piece.moved = true
  end

  def long_castling(row)
    @grid[row][3].piece = @grid[row][0].piece.clone
    @grid[row][0].piece = nil
    @grid[row][2].piece = @grid[row][4].piece.clone
    @grid[row][4].piece = nil

    @grid[row][3].piece.moved = true
    @grid[row][2].piece.moved = true
  end
end