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
  end

  def name_for_player(player_number)
    puts d_ask_player_name(player_number)
    print d_user_name_indicator
    player_name = gets.chomp
    player_name = gets.chomp until valid_player_name?(player_name)
    player_name
  end

  def valid_player_name?(name)
    return true if name.size > 3

    puts d_invalid_name
    print d_user_name_indicator
  end

  def new_chess_game_started
    @board = Board.new
    @board.order_pieces
    @current_player = @player_one
    until game_ended? || save_game?
      player_turn(current_player)
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
    true
  end

  def current_player_change
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end
end