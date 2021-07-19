# frozen_string_literal: true

require_relative 'display'
require_relative 'board'

class Game
  include Display

  def initialize
    @board = nil
    @player_one = nil
    @player_two = nil
    @current_player = nil
  end

  def play
    welcome
    menu
  end

  def welcome
    puts d_welcome_msg
  end

  def menu(user_choice = '')
    until user_choice == 3
      user_choice = menu_options
      case user_choice
      when 1
        puts 'LOADING GAME...'
      when 2
        new_game
      when 3
        puts d_goodbye_msg
      end
    end
  end

  def menu_options
    puts d_menu_options
    print d_user_choice_indicator
    key = gets.chomp
    key = gets.chomp until valid_menu_option?(key)
    key.to_i
  end

  def valid_menu_option?(key)
    return true if key != '' && '123'.include?(key) && key.size == 1

    puts d_invalid_option
    print d_user_choice_indicator
  end

  def new_game
    puts d_new_game
    set_player_names
    new_chess_game_started
  end

  def set_player_names
    @player_one = name_for_player(1)
    @player_two = name_for_player(2)
    puts both_players_well_created(@player_one, @player_two)
  end

  def name_for_player(player_number)
    puts d_ask_player_name(player_number)
    print d_user_name_indicator
    player_name = gets.chomp
    player_name = gets.chomp until valid_player_name?(player_name)
    puts player_created(player_name)
    player_name
  end

  def valid_player_name?(name)
    return true if name.size > 3

    puts d_invalid_name
    print d_user_name_indicator
  end

  def new_chess_game_started
    @board = Board.new(@player_one, @player_two)
    @board.order_pieces
    @current_player = @player_one
    until game_ended? || save_game?
      display_board(@board.grid)
      player_turn(@current_player)
      current_player_change
    end
  end

  def game_ended?
    false
  end

  def save_game?
    false
  end

  def player_turn(player, turn_finished = false)
    puts display_player_turn_msg(player)
    until turn_finished
      piece_to_move = get_piece_to_move
      parsed_pos_moves = @board.get_pos_moves(piece_to_move)
      if parsed_pos_moves.empty?
        puts display_no_moves_available
        next
      end
      puts display_select_slot_to_go(piece_to_move, parsed_pos_moves)
      place_to_move = get_slot_to_go(parsed_pos_moves)
      next if king_in_check(piece_to_move, place_to_move)
      @board.move(piece_to_move, place_to_move)
      turn_finished = true
    end
  end

  def get_piece_to_move(piece = nil)
    piece = gets.chomp.downcase until valid_piece_to_move?(piece)

    puts display_valid_piece(piece)
    piece
  end

  def get_slot_to_go(moves, place = nil)
    place = gets.chomp.downcase until valid_place_to_go?(place, moves)

    place
  end


  def valid_place_to_go?(place, moves)
    return false if place.nil?

    return true if format_checker(place) && moves.include?(place)

    puts display_invalid_place_to_go(place, moves)
  end

  def valid_piece_to_move?(piece)
    return false if piece.nil?

    piece_color = @current_player == @player_one ? 'white' : 'black'

    true if format_checker(piece) && @board.valid_piece_selected?(piece, piece_color)
  end

  def king_in_check(piece_to_move, place_to_move)
    fake_board = Board.new(@player_one, @player_two)
    fake_board.grid.each_with_index do |row, idx_row|
      row.each_with_index do |slot, idx_column|
        fake_board.grid[idx_row][idx_column] = @board.grid[idx_row][idx_column].clone
      end
    end
    fake_board.move(piece_to_move, place_to_move, fake_board.grid)
    display_board(@board.grid)
    display_board(fake_board.grid)
    false
  end

  def format_checker(piece)
    return true if !piece.nil? && piece.size == 2 && piece[0].between?('a', 'h') && piece[1].between?('1', '8')

    puts display_invalid_piece_to_move
    false
  end

  def current_player_change
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end
end
