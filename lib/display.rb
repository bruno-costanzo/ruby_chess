# frozen_string_literal: true

require 'colorize'

module Display

  def d_welcome_msg
    "  Welcome to Chess  \n".colorize(:black).on_yellow
  end

  def d_invalid_option
    "Invalid option. Please enter '1' to Load Game, '2' for New Game or '3' for Quit"
  end

  def d_menu_options
    "Main Menu\n\t1. Load Game\n\t2. New Game\n\t3. Quit\n"
  end

  def d_user_choice_indicator
    "Option number \u2192 ".colorize(:yellow)
  end

  def d_goodbye_msg
    'Thank you for playing Chess. Goodbye!'
  end

  def d_new_game
    "\nNew Game".colorize(:cyan)
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
    "Both players well created.\n\n\t" + "- Cyan pieces: #{p1}.".colorize(:cyan) + "\n\t- Black Pieces: #{p2}.".colorize(:white).on_black + "\n\n"
  end

  def player_created(player)
    "Player created: #{player}\n"
  end

  def display_player_turn_msg(player)
    "#{player}, is your turn. Select the piece you want to move. Example: d2 or b1"
  end

  def display_invalid_piece_to_move
    'Invalid format. Check the grid and select column-row. Example: d2 or g1'
  end

  def display_valid_piece(piece)
    "Piece in location #{piece.colorize(:yellow)} selected."
  end

  def display_select_slot_to_go(piece, moves)
    "Where do you want to move the piece placed at #{piece.colorize(:yellow)}? Posibilities: #{moves.to_s.gsub('"', '').colorize(:light_cyan)}"
  end


  def display_invalid_place_to_go(place, moves)
    "You can't move the piece to #{place.colorize(:yellow)}. The options are: #{moves.to_s.gsub('"', '').colorize(:light_cyan)}"
  end

  def display_no_moves_available
    'There is not available moves. Try again. Select the piece you want to move.'
  end

  def display_king_in_check(player, piece_to_move)
    puts "#{player}, you can't make that move because your king would be in check. Select a piece to move again"

    true
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

  def display_no_piece_there
    'There is not a piece in that position.'
  end

  def display_not_player_piece
    "That's not your piece. Please select a piece you own."
  end
end
