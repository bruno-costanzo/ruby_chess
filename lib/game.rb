# frozen_string_literal: true

require_relative 'display'
require_relative 'board'
require_relative 'database'

class Game
  attr_accessor :current_player, :board, :player_one, :player_two

  include Display
  include Database

  def initialize
    @board = nil
    @player_one = nil
    @player_two = nil
    @current_player = nil
    @fake_board = nil
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
        loaded_game = load_game
        @board = loaded_game.board
        @player_one = loaded_game.player_one
        @player_two = loaded_game.player_two
        @current_player = loaded_game.current_player
        current_player_change
        game_workflow
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

  def new_chess_game_started(save = false)
    @board = Board.new(@player_one, @player_two)
    @board.order_pieces
    @current_player = @player_one
    moves = @board.player_turn_started(player_color)
    game_workflow
  end

  def game_workflow(save = false, moves = @board.player_turn_started(player_color))
    until game_ended? || save
      display_board(@board.grid)
      save = player_turn(@current_player, moves)
      current_player_change
      moves = @board.player_turn_started(player_color)
    end

    save_game if save
  end

  def save_game
    db_save_game
  end

  def game_ended?(moves = @board.player_turn_started(player_color), wking = @board.king_position('white'), bking = @board.king_position('black'))

    if moves.empty? || wking.nil? || bking.nil?
      current_player_change
      display_board(@board.grid)
      puts display_checkmate(@current_player)
      return true
    end

    false
  end

  def player_turn(player, moves)
    puts display_player_turn_msg(player)
    check_warning(moves)
    piece_to_move = parse_position(get_piece_to_move) until valid_piece_taken?(piece_to_move, moves)

    if piece_to_move == 'ca' || piece_to_move == 'ch'
      puts 'castling...'
      return false
    end
    return true if save_the_game?(piece_to_move)

    piece_end_moves = @board.get_piece_moves(piece_to_move, moves)
    puts display_select_slot_to_go(inversed_parse(piece_to_move), parsed_pos_moves(piece_end_moves))
    place_to_move = parse_position(get_slot_to_go(parsed_pos_moves(piece_end_moves))) until piece_end_moves.include?(place_to_move)
    @board.move(piece_to_move, place_to_move)
    @board.pawn_to_queen(place_to_move, player_turn_color) if @board.pawn_end_board?(place_to_move)

    false
end

  def save_the_game?(piece)
    return false if piece.instance_of?(Array)
return true if "sS".include?(piece)
  end

  def player_turn_color
    @current_player == @player_one ? 'white' : 'black'
  end

  def parsed_pos_moves(moves, result = [])
    moves.each do |move|
      result << inversed_parse(move)
    end

    result
  end

  def inversed_parse(position)
    column_letters = ('a'..'h').to_a
    row_numbers = ('1'..'8').to_a.reverse

    "#{column_letters[position[1]]}#{row_numbers[position[0]]}"
  end

  def valid_piece_taken?(piece_to_move, moves)
    return false if piece_to_move.nil?

    moves.each do |move|
      return true if move[0] == piece_to_move
    end

    return true if (piece_to_move.instance_of?(String) && 'sS'.include?(piece_to_move)) || ((piece_to_move == 'ca' || piece_to_move == 'ch') && @board.valid_castling_caller(piece_to_move, player_turn_color))

    puts display_invalid_piece_taken(inversed_parse(piece_to_move)) unless piece_to_move == 'ca' || piece_to_move == 'ch'

    false
  end

  def player_color
    @current_player == @player_one ? 'black' : 'white'
  end

  def check_warning(moves)
    white_king = @board.king_position('white')
    black_king = @board.king_position('black')
    if @board.check?(@board, white_king, 'white')
      puts display_check_warning('white')
    elsif @board.check?(@board, black_king, 'black')
      puts display_check_warning('black')
    end

    false
  end

  def get_piece_to_move(piece = nil)
    piece = gets.chomp.downcase until valid_piece_to_move?(piece)
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

    true if piece == 'ca' || piece == 'ch' || 'sS'.include?(piece) || format_checker(piece) && @board.valid_piece_selected?(piece, piece_color)
  end

  def format_checker(piece)
    return true if !piece.nil? && piece.size == 2 && piece[0].between?('a', 'h') && piece[1].between?('1', '8')

    puts display_invalid_piece_to_move
    false
  end

  def current_player_change
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def parse_position(piece)
    return piece if 'sS'.include?(piece) || piece == 'ca' || piece == 'ch'

    column_letters = ('a'..'h').to_a
    row_numbers = ('1'..'8').to_a.reverse
    column = column_letters.index(piece.split('')[0])
    row = row_numbers.index(piece.split('')[1])

    [row, column]
  end
end
