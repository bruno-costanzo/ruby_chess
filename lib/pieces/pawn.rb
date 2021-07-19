# frozen_string_literal: true

class Pawn
  POS_W_MVS = [[-1, 0]].freeze
  POS_W_FIRST_MVS = [[-1, 0], [-2, 0]].freeze
  POS_W_ATTACK_MVS = [[-1, -1], [-1, 1]].freeze

  POS_B_MVS = [[1, 0]].freeze
  POS_B_FIRST_MVS = [[1, 0], [2, 0]].freeze
  POS_B_ATTACK_MVS = [[1, 1], [1, -1]].freeze

  attr_accessor :color, :symbol, :moved

  def initialize(color = nil)
    @color = color
    @symbol = ["\u2659", "\u265F"]
    @moved = false
  end


  def possible_moves(position, grid, moves = [])
    moves = @color == 'white' ? pos_white_moves(position, grid) : pos_black_moves(position, grid)
  end

  def valid_attack_piece(grid, possible_move)
    !grid[possible_move[0]][possible_move[1]].nil? && !grid[possible_move[0]][possible_move[1]].piece.nil? && grid[possible_move[0]][possible_move[1]].piece.color != color
  end

  def pos_white_moves(position, grid, result = [])
    if !@moved
      POS_W_FIRST_MVS.each do |move|
        new_move = [position[0] + move[0], position[1] + move[1]]
        result << new_move if grid[new_move[0]][new_move[1]].piece.nil?
      end
    else
      POS_W_MVS.each do |move|
        new_move = [position[0] + move[0], position[1] + move[1]]
        result << new_move if grid[new_move[0]][new_move[1]].piece.nil?
      end
    end
    POS_W_ATTACK_MVS.each do |move|
      possible_move = [position[0] + move[0], position[1] + move[1]]
      result << possible_move if valid_attack_piece(grid, possible_move)
    end

    result
  end

  def pos_black_moves(position, grid, result = [])
    if !@moved
      POS_B_FIRST_MVS.each do | move |
        new_move = [position[0] + move[0], position[1] + move[1]]
        result << new_move if grid[new_move[0]][new_move[1]].piece.nil?
      end
    else
      POS_B_MVS.each do | move |
        new_move = [position[0] + move[0], position[1] + move[1]]
        result << new_move if grid[new_move[0]][new_move[1]].piece.nil?
      end
    end
    POS_B_ATTACK_MVS.each do |move|
      possible_move = [position[0] + move[0], position[1] + move[1]]
      result << possible_move if valid_attack_piece(grid, possible_move)
    end

    result
  end
end
