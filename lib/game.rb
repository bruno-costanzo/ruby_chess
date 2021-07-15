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

  def player_turn(player)
    puts display_player_turn_msg(player)
    piece_to_move = get_piece_to_move

    puts display_select_slot_to_go(piece_to_move)
    place_to_move = get_slot_to_go
  end

  def get_piece_to_move(piece = nil)
    piece = gets.chomp.downcase until valid_piece_to_move?(piece)

    puts display_valid_piece(piece)
    piece
  end

  def get_slot_to_go(place = nil)
    place = gets.chomp.downcase until valid_place_to_go?(place)
  end


  def valid_place_to_go?(place)
    return false if place.nil?

    true if format_checker(place)
  end

  def valid_piece_to_move?(piece)
    return false if piece.nil?

    piece_color = @current_player == @player_one ? 'white' : 'black'

    true if format_checker(piece) && @board.valid_piece_selected?(piece, piece_color)
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
