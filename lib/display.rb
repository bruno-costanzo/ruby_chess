# frozen_string_literal: true

require 'colorize'

module Display

  def d_welcome_msg
    "Welcome to Chess\n\n"
  end

  def d_invalid_option
    "Invalid option. Please enter '1' to Load Game, '2' for New Game or '3' for Quit"
  end

  def d_menu_options
    "Main Menu\n\t1. Load Game\n\t2. New Game\n\t3. Quit\n"
  end

  def d_user_choice_indicator
    "Option number \u2192 "
  end

  def d_goodbye_msg
    'Thank you for playing Chess. Goodbye!'
  end

  def d_new_game
    "\nNew Game"
  end

  def d_ask_player_name(player_number)
    "\tChoose a name for Player #{player_number}. It must have 4+ characters\n"
  end

  def d_user_name_indicator
    "\u2192 "
  end

  def d_invalid_name
    'Invalid name. It must have 4+ characters. Try again'
  end

  def both_players_well_created(p1, p2)
    "Both players well created.\nCyan pieces: #{p1}.\nBlack Pieces: #{p2}."
  end

  def player_created(player)
    "Player created: #{player}"
  end

  def display_player_turn_msg(player)
    "#{player}, is your turn. Select the piece you want to move. Example: D2 or B1"
  end

  # BOARD

  def display_board(grid)
    idx = 8
    grid.each do |row|
      print " #{idx} "
      idx -= 1
      row.each do |slot|
        color_key = slot.piece.color == 'white' ? 0 : 1 unless slot.piece.nil?
        bg_col = slot.color == 'black' ? :light_black : :white
        piece_color = slot.piece.color == 'black' ? :black : :cyan unless slot.piece.nil?
        print " #{slot.piece.symbol[color_key]}  ".colorize(color: piece_color, background: bg_col) if slot.piece
        print '    '.colorize(background: bg_col) if slot.piece.nil?
      end
      print "\n"
    end
    print "    A   B   C   D   E   F   G   H   \n\n"
  end
end
